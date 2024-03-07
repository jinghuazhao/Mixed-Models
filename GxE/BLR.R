#$ -S /usr/local/bin/Rscript
#$ -N BLR
#$ -cwd
#$ -o BLR.o
#$ -e BLR.e
#$ -pe make 5
#$ -q all.q

# 9-5-2018 JHZ

.libPaths("/genetics/bin/R")
library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2)
   ID <<- order(id)
})
N <- length(y)
eps <- 0.05
library(BLR,lib.loc="/genetics/bin/R")
m <- BLR(y, XF=X, GF=list(ID=ID, A=GRM+diag(eps,N)),
         prior=list(varU=list(df=3,S=5), varE=list(df=3,S=10)),
         nIter=100000, burnIn=10000, thin=1, saveAt="BLR_")
save(m, file="BLR.fit")
eps <- ifelse(exists("eps"),eps,0)
attach(m)
fit
varE <- varE + eps * varU
varU/(varU+varE)
detach(m) 
g <- scan("BLR_varU.dat",skip=10000)
e <- scan("BLR_varE.dat",skip=10000)
h2 <- g/(g+e+g*eps)
library(coda)
r <- as.mcmc(cbind(g,e,h2))
summary(r)
HPDinterval(r)
pdf("BLR.pdf")
plot(r)
dev.off()
