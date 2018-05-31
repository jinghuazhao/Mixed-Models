#24-4-2018 MRC-Epid JHZ

library(foreign)
test <- read.dta("test.dta")
N = 3925
lm(y~sex,data=test)
library(gap)
g <- ReadGRMBin("test")
library(regress)
r <- with(g,regress(y ~ sex, ~GRM, data=test))
r
with(r,{
  print(sqrt(sigma+1.96*sqrt(diag(sigma.cov))))
  h2G(sigma,sigma.cov)
})
eps <- 1
library(BLR)
library(coda)
attach(test)
m <- BLR(y=matrix(y,N),
         XF=as.matrix(cbind(sex)),
         GF=list(ID=order(g$id[,2]),A=g$GRM+diag(eps,N)),
         prior=list(varU=list(df=3,S=11),varE=list(df=3,S=11)),
         nIter=10000,burnIn=5000,thin=1, saveAt="BLR_")
save(m,file="BLR.fit")
detach(test)
library(coda)
U <- scan("BLR_varU.dat")
E <- scan("BLR_varE.dat")
h2 <- U/((1+eps)*U+E)
U <- as.mcmc(U)
E <- as.mcmc(E)
h2 <- as.mcmc(h2)
summary(h2)
summary(U)
summary(E)
HPDinterval(h2,probs=0.95)
HPDinterval(U,probs=0.95)
HPDinterval(E,probs=0.95)
pdf("BLR.pdf")
par(mfrow=c(3,2))
plot(h2)
plot(U)
plot(E)
dev.off()
attach(m)
names(m)
fit
varU
varE
varU/((1+eps)*varU+varE)
detach(m)
