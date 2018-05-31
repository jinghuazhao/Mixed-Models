library("gap")
g <- ReadGRM("GRM")
library("BLR")
load("p.rda")
attach(p)
N <- nrow(p)
eps <- 0.1
m <- BLR(y = matrix(r, N),
         GF = list(ID = 1:N, A = g$GRM + diag(eps, N)), 
         prior = list(varU = list(df = 3, S = 11), varE = list(df = 3, S = 11)), 
         nIter = 500000, burnIn = 150000, thin = 1, saveAt = "fgh.BLR_")
save(m, file = "fgh.BLR.fit")
library("coda")
U <- as.mcmc(scan("fgh.BLR_varU.dat")[-(1:150000)])
E <- as.mcmc(scan("fgh.BLR_varE.dat")[-(1:150000)])
e <- as.mcmc(cbind(U, E, h2 = U / ((1 + eps) * U + E)))
summary(e)$statistics
HPDinterval(e)
png("fgh_BLR.png", height = 15, width = 15, units = "cm", res = 300)
plot(e)
dev.off()
whichNa <- is.na(r)
detach(p)
attach(m)
names(m)
varU
varE
fit
varU / ((1 + eps) * varU + varE)
detach(m)
pdf("fgh.BLR.pdf")
par(mfrow = c(3, 2))
traceplot(U); densplot(U)
traceplot(E); densplot(E)
traceplot(h2); densplot(h2)
dev.off()
