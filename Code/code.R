library("coda")
library("gap")
library("lattice")
print <- function(x, ...) {
  if (is.numeric(x)) base::print(round(x, digits = 3),...)
  else base::print(x, ...)
}

###################################################
### 3. Benchmark
###################################################

### 3.1. Frequentist approach
set.seed(1234567)
meyer <- within(meyer, {
  y[is.na(y)] <- rnorm(length(y[is.na(y)]), 
    mean(y, na.rm = TRUE), sd(y, na.rm = TRUE))
  g1 <- ifelse(generation == 1, 1, 0)
  g2 <- ifelse(generation == 2, 1, 0)
  id <- animal
  animal <- ifelse(!is.na(animal), animal, 0)
  dam <- ifelse(!is.na(dam), dam, 0)
  sire <- ifelse(!is.na(sire), sire, 0)
})
G <- kin.morgan(meyer)$kin.matrix * 2
library("regress")
r <- regress(y ~ -1 + g1 + g2, ~ G, data = meyer)
r
with(r, h2G(sigma, sigma.cov))

### 3.2. Bayesian approach

### JAGS
C <- chol(G)
N <- dim(meyer)[1]
data <- with(meyer,
  list(N = N, y = y, g1 = g1, g2 = g2, u = rep(0, N), GI = solve(G)))
inits <- function() {
    list(b1 = 0, b2 = 0, tau.p = 0.03, tau.r = 0.014)
}
parms <- c("b1", "b2", "p", "r", "h2")

### Inverse gamma priors
modelfile <- function() {
  b1 ~ dnorm(0, 0.000001)
  b2 ~ dnorm(0, 0.000001)
  tau.p ~ dgamma(0.001, 0.001)
  tau.r ~ dgamma(0.001, 0.001)
  sigma.p <- 1 / sqrt(tau.p)
  sigma.r <- 1 / sqrt(tau.r)
  g[1:N] ~ dmnorm(u[], GI[, ] / p)
  for (i in 1:N) {
      y[i] ~ dnorm(b1 * g1[i] + b2 * g2[i] + g[i], tau.r)
  }
  p <- pow(sigma.p, 2)
  r <- pow(sigma.r, 2)
  h2 <- p / (p + r)
}
library("R2jags")
jagsfit <- jags(data, inits, parms, modelfile, n.chains = 2, 
  n.burnin = 500, n.iter = 5000)
jagsfit

### Cholesky decomposition, uniform priors
data <- with(meyer, list(N = N, y = y, g1 = g1, g2 = g2, C = t(C)))
inits <- function() list(b1 = 0, b2 = 0, sigma.p = 0.03, sigma.r = 0.014)
modelfile <- function() {
  b1 ~ dnorm(0, 0.001)
  b2 ~ dnorm(0, 0.001)
  sigma.p ~ dunif(0, 1000)
  sigma.r ~ dunif(0, 1000)
  p <- pow(sigma.p, 2)
  r <- pow(sigma.r, 2)
  tau <- pow(sigma.r, -2)
  g[1:N] <- sigma.p * C[, ] %*% z[]
  for (i in 1:N) {
      z[i] ~ dnorm(0, 1)
  }
  for (i in 1:N) {
      y[i] ~ dnorm(b1 * g1[i] + b2 * g2[i] + g[i], tau)
  }
  h2 <- p / (p + r)
}
jagsfit2 <- jags(data, inits, parms, modelfile, 
  n.chains = 2, n.burnin = 500, n.iter = 5000)
jagsfit2

### Stan
data <- with(meyer, list(N = N, y = y, g1 = g1, g2 = g2, G = G))
library("rstan")
meyer.stan <- "
data {
  int N;
  vector[N] y;
  vector[N] g1;
  vector[N] g2;
  matrix[N, N] G;
}
transformed data {
  matrix[N, N] C;
  C = cholesky_decompose(G);
}
parameters {
  vector[2] b;
  vector[N] z;
  real sigma_p2;
  real sigma_r2;
}
transformed parameters {
  real sigma_p;
  real sigma_r;
  vector[N] g;
  sigma_p = sqrt(sigma_p2);
  sigma_r = sqrt(sigma_r2);
  g = sigma_p * C * z;
}
model {
  b ~ normal(0, 1000);
  sigma_p2 ~ inv_gamma(0.001, 0.001);
  sigma_r2 ~ inv_gamma(0.001, 0.001);
  z ~ normal(0, 1);
  y ~ normal(b[1] * g1 + b[2] * g2 + g, sigma_r);
}
generated quantities {
  real h2;
  real p;
  real r;
  p = sigma_p2;
  r = sigma_r2;
  h2 = p / (p + r);
}
"
parms <- c("b", "p", "r", "h2")
f1 <- stan(model_code = meyer.stan, data = data, chains = 2, iter = 500, 
  verbose = FALSE)
f2 <- stan(fit = f1, data = data, chains = 2, iter = 5000, pars = parms,
  verbose = FALSE)

print(f2, pars = parms, digits_summary = 3)
stan2coda <- function(fit) {
    mcmc.list(lapply(1:ncol(fit), function(x) mcmc(as.array(fit)[, x, ])))
}  
m <- stan2coda(f2)
gelman.diag(m)

densityplot(m)
plot(as.mcmc(as.data.frame(extract(f2, pars = c("p", "r", "h2")))))

library("R2OpenBUGS")
data <- with(meyer, list(N = N, y = y, g1 = g1, g2 = g2, G = G))
bugs.data(data, data.file = "meyer_bugs.txt")
library("coda")
bugs2jags("meyer_bugs.txt", "meyer_stan.txt")


## Using cmdstan:
## $ make meyer
## $ ./meyer sample data file=meyer_stan.txt output file=meyer.csv
## $ stansummary meyer.csv

###################################################
### 4. Additional considerations
###################################################

### 4.1. Parallel computation

### JAGS

library("R2jags")
data <- with(meyer, list(N = N, y = y, g1 = g1, g2 = g2, C = t(C)))
inits <- function() list(b1 = 0, b2 = 0, sigma.p = 0.03, sigma.r = 0.014)
parms <- c("b1", "b2", "p", "r", "h2")
out <- jags.parallel(data, inits, parms, modelfile, n.chains = 4,
                     n.burnin = 500, n.iter = 5000)

### Stan

library("parallel")
data <- with(meyer, list(N = N, y = y, g1 = g1, g2 = g2, G = G))
f1 <- stan(model_code = meyer.stan, data = data, chains = 4, iter = 500,
           verbose = FALSE)
l <- mclapply(1:4, mc.cores = 4, function(i)
    stan(fit = f1, seed = 12345, data = data, iter = 5000,
         chains = 1, chain_id = i, refresh = -1))
f2 <- sflist2stanfit(l)

options(mc.cores = parallel::detectCores() - 1)

### 4.2. Nonpositive definite G matrix

modelfile <- function() {
  b1 ~ dnorm(0, 0.000001)
  b2 ~ dnorm(0, 0.000001)
  sigma.p ~ dunif(0, 1000)
  sigma.r ~ dunif(0, 1000)
  p <- pow(sigma.p, 2)
  r <- pow(sigma.r, 2)
  tau <- pow(sigma.r, -2)
  g[1:N] ~ dmnorm(u[], inverse(p * G[, ] + eps * I[, ]))
  for (i in 1:N) {
    y[i] ~ dnorm(b1 * g1[i] + b2 * g2[i] + g[i], tau)
  }
  h2 <- p / (p + r)
}

library("R2jags")
I <- diag(nrow = nrow(G))
eps <- 0.001
data <- with(meyer,
  list(N = N, y = y, g1 = g1, g2 = g2, u = rep(0, N), G = G,
       eps = eps, I = I))
inits <- function() list(b1 = 0, b2 = 0)
parms <- c("b1", "b2", "p", "r", "h2")
jagsfit <- jags(data, inits, parms, modelfile, n.chains = 2, 
  n.burnin = 500, n.iter = 5000)
jagsfit

###################################################
### 5. Application: familial vs genomic heritabilities
###################################################

### See directory fgh.

###################################################
### 6. Summary
###################################################

u <- rep(0, N)
data <- with(meyer, list(N = N, y = y, g1 = g1, g2 = g2, u = u, G = G))
library("rstan")

### Missing outcome
set.seed(1234567)
meyer <- within(meyer, {
  yNa <- y
  g1 <- ifelse(generation == 1, 1, 0)
  g2 <- ifelse(generation == 2, 1, 0)
  id <- animal
  animal <- ifelse(!is.na(animal), animal, 0)
  dam <- ifelse(!is.na(dam), dam, 0)
  sire <- ifelse(!is.na(sire), sire, 0)
})
G <- kin.morgan(meyer)$kin.matrix * 2
library("regress")
r <- regress(y ~ -1 + g1 + g2, ~ G, data = meyer)
r
library("BLR")
attach(meyer)
X <- as.matrix(meyer[c("g1","g2")])
m <- BLR(yNa, XF = X, GF = list(ID = 1:nrow(G), A = G),
  prior = list(varE = list(df = 1, S = 0.25), 
  varU = list(df = 1, S = 0.63)),
  nIter = 5000, burnIn = 500, thin = 1, saveAt = "meyer.BLR")
detach(meyer)

with(r, h2G(sigma, sigma.cov))
names(m)
attach(m)
yHat[whichNa]
mu
bF
mu + bF
varU
varE
varU / (varU + varE)


