#29-2-2012 MRC-Epid JHZ

library(foreign)
nf <- read.dta("nuclearfamily.dta")

library(kinship)
attach(nf)
f <- makefamid(shareid, fshare, mshare)
k <- makekinship(f, shareid, fshare, mshare)
detach(nf)
cc <- coxme.control(inner.iter=10)
#cat("Cox model with frailty\n")
#f0 <- coxph(Surv(agediab, diabetes) ~1+frailty(pedno, dist="gamma"), data=nf)
#f0
cat("Cox model with random intercept\n")
f1 <- coxme(Surv(agediab, diabetes) ~1, nf, random=~1|pedno, control=cc)
f1
cat("Cox model with random intercept and additive variance")
f2 <- coxme(Surv(agediab, diabetes) ~1, nf, random=~1|shareid, varlist=list(k), control=cc)
print(f2)
