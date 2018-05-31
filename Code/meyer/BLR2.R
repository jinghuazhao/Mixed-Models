library("gap")
set.seed(1234567)
meyer <- within(meyer, {
    y[is.na(y)] <- rnorm(length(y[is.na(y)]), mean(y, na.rm = TRUE), sd(y, na.rm = TRUE))
    yNa <- y
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
with(r, h2G(sigma, sigma.cov))
library("BLR")
attach(meyer)
X <- as.matrix(meyer[c("g1", "g2")])
m <- BLR(yNa, XF = X, GF = list(ID = 1:nrow(G), A = G), 
         prior = list(varE = list(df = 1, S = 0.25), varU = list(df = 1, S = 0.63)), 
         nIter = 10000, burnIn = 5000, thin = 1, saveAt = "BLR2_")
save(m, file = "BLR2.fit")
detach(meyer)
names(m)
attach(m)
yHat[whichNa]
fit
mu
bF
mu + bF
SD.bF
varU
varE
varU / (varU + varE)
detach(m)
library("coda")
bF <- read.table("BLR2_bF.dat", col.names = c("b1", "b2"))
summary(as.mcmc(bF))
varU <- scan("BLR2_varU.dat")
varE <- scan("BLR2_varE.dat")
h2 <- varU / (varU + varE)
summary(as.mcmc(h2))
