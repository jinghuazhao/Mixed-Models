## Using family structure

load("p.rda")
library("AnimalINLA")
library("pedigree")
trios <- add.Inds(p[c("id", "fid", "mid")])
trios[is.na(trios)] <- 0
data <- merge(trios, p[c("id", "r")], by = "id", all.x = TRUE)
nr <- nrow(data)
p2 <- data.frame(data, u = seq_len(nr), e = seq_len(nr))
p2 <- within(p2, id <- as.integer(id))
xx <- compute.Ainverse(p2[c("id", "fid", "mid")])
fit <- animal.inla(
    response = "r", fixed = NULL, 
    genetic = "id", Ainverse = xx, 
    type.data = "gaussian", data = p2, 
    sigma.e = TRUE, dic = TRUE)
save(p2, xx, fit, file = "AnimalINLA.fit")
library("coda")
summary(fit)
attach(fit)
summary.hyperparam
pdf("AnimalINLA.pdf")
par(mfrow = c(3, 1))
plot(sigma.u, type = "l", ylab = "Posterior", 
     xlab = expression(paste(sigma[u]^2)))
plot(sigma.e, type = "l", ylab = "Posterior", 
     xlab = expression(paste(sigma^2)))
plot(gaussian.h, type = "l", ylab = "Posterior", 
     xlab = expression(paste(h^2)), xlim = c(0, 1))
par(mfrow = c(3, 2))
h2 <- as.mcmc(gaussian.h[, 1])
u <- as.mcmc(sigma.u[, 1])
e <- as.mcmc(sigma.e[, 1])
traceplot(h2); densplot(h2)
traceplot(u); densplot(u)
traceplot(e); densplot(e)
dev.off()
detach(fit)
