library("coda")
library("gap")
meyer <- within(meyer, {
    g1 <- ifelse(generation == 1, 1, 0)
    g2 <- ifelse(generation == 2, 1, 0)
    id <- animal
    animal <- ifelse(!is.na(animal), animal, 0)
    dam <- ifelse(!is.na(dam), dam, 0)
    sire <- ifelse(!is.na(sire), sire, 0)
})
G <- kin.morgan(meyer)$kin.matrix * 2
C <- chol(G)
N <- dim(meyer)[1]
data <- with(meyer, list("y", "g1", "g2", "C", "N"))
inits <- function() list(b1 = 0, b2 = 0, tau.p = 0.03, tau.r = 0.014)
parms <- c("b1", "b2", "p", "r", "h2")
modelfile <- function() {
    b1 ~ dnorm(0, 0.000001)
    b2 ~ dnorm(0, 0.000001)
    tau.p ~ dgamma(0.001, 0.001)
    tau.r ~ dgamma(0.001, 0.001)
    sigma.p <- 1/sqrt(tau.p)
    sigma.r <- 1/sqrt(tau.r)
    g[1:N] <- sigma.p * C[, ] %*% z[]
    for (i in 1:N) {
        z[i] ~ dnorm(0, 1)
    }
    for (i in 1:N) {
        y[i] ~ dnorm(b1 * g1[i] + b2 * g2[i] + g[i], tau.r)
    }
    p <- pow(sigma.p, 2)
    r <- pow(sigma.r, 2)
    h2 <- p / (p + r)
}
library("R2jags")
attach(meyer)
out <- jags.parallel(data, inits, parms, modelfile,
                     n.chains = 4, n.burnin = 50, n.iter = 300)
detach(meyer)
