#29-2-2012 MRC-Epid JHZ

library(foreign)
nf <- read.dta("nuclearfamily.dta")

library(kinship2)
attach(nf)
f <- makefamid(shareid, fshare, mshare)
k <- makekinship(f, shareid, fshare, mshare)
detach(nf)

save(nf,k,file="nf.RData")
