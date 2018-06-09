#29-2-2012 MRC-Epid JHZ

library(kinship2)
library(bdsmatrix)
load("nf.RData")
load("jinghua/IBD/k.RData")

library(coxme)

cat("random intercept\n")
f1 <- coxme(Surv(agediab, diabetes) ~ sex + (1|pedno), nf)
f1

cat("structure-based kinship\n")
k <- as.matrix(k)
f2 <- coxme(Surv(agediab, diabetes) ~ sex + (1|shareid), nf, varlist=coxmeMlist(k))
print(f2)

cat("SNP-inferred kinship\n")
i <- bdsI(dim(k2)[[1]],k2@blocksize)
i@Dimnames <- k2@Dimnames
f3 <- coxme(Surv(agediab, diabetes) ~ sex + (1|shareid), nf, varlist=coxmeMlist(list(i,2*k2),rescale=FALSE,pdcheck=FALSE))
print(f3)
