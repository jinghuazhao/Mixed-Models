#29-2-2012 MRC-Epid JHZ

library(kinship2)
library(coxme)
load("/home/jhz22/mrc/papers/jps/nf.RData")
load("/fram/data/jinghua/IBD/k.RData")
i <- bdsI(dim(k2)[[1]],k2@blocksize)
i@Dimnames <- k2@Dimnames

cat("Linear model with random intercept\n")
l1 <- lmekin(bmi1 ~ sex + (1|pedno), nf)
l1

cat("structure-based kinship")
k2 <- as.matrix(k)
l2 <- lmekin(bmi1 ~ sex + (1|shareid), nf, varlist=coxmeMlist(k2))
print(l2)

cat("SNP-inferred kinship")
l3 <- lmekin(bmi1 ~ sex + (1|shareid), nf, varlist=coxmeMlist(list(i,2*k2),rescale=FALSE,pdcheck=FALSE))
print(l3)
