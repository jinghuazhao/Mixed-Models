library("gap")
set.seed(1234567)
meyer <- within(meyer, {
    y[is.na(y)] <- rnorm(length(y[is.na(y)]), mean(y, na.rm = TRUE), sd(y, na.rm = TRUE))
    g1 <- ifelse(generation == 1, 1, 0)
    g2 <- ifelse(generation == 2, 1, 0)
    id <- animal
    animal <- ifelse(!is.na(animal), animal, 0)
    dam <- ifelse(!is.na(dam), dam, 0)
    sire <- ifelse(!is.na(sire), sire, 0)
})
G <- kin.morgan(meyer)$kin.matrix*2
library("regress")
r <- regress(y ~ -1 + g1 + g2, ~ G, data = meyer)
r
with(r, {
  l1 <<- sqrt(sigma[1] + 1.96*sqrt(sigma.cov[1, 1]))
  l2 <<- sqrt(sigma[2] + 1.96*sqrt(sigma.cov[2, 2]))
  h2G(sigma, sigma.cov)
})
N <- dim(meyer)[1]
u <- rep(0, N)
with(meyer, dump(c("N", "l1", "l2", "y", "g1", "g2", "u", "G"), "meyer.dump"))
data <- with(meyer, list(N = N, l1 = l1, l2 = l2, y = y, g1 = g1, g2 = g2, u = u, G = G))
library("rstan")
library("parallel")
parms <- c("b", "p", "r", "h2")
f1 <- stan("meyer.stan", data = data, chains = 1, iter = 1, verbose = FALSE)
WINDOWS <- .Platform$OS.type == "windows"
l <- mclapply(1:4, mc.cores = ifelse(WINDOWS, 1, 8), function(i)
    stan(fit = f1, seed = 12345, data = data, iter = 1000, 
         chains = 1, chain_id = i, refresh = -1))
f2 <- sflist2stanfit(l)
save(f2, file = "pmeyer.fit")
print(f2, pars = parms, digits_summary = 3)
pdf("pmeyer.pdf")
plot(f2, pars = parms)
rstan::traceplot(f2, pars = parms)
dev.off()
