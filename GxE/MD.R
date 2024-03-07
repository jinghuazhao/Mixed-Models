#$ -S /usr/local/bin/Rscript
#$ -N MD
#$ -cwd
#$ -o MD.o
#$ -e MD.e
#$ -pe make 5
#$ -q all.q

# 10-5-2018 JHZ

library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
# GRM <- GRM/mean(diag(GRM))
mdGRM <- with(ReadGRMBin("MD"),GRM)
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   MD <- as.numeric(mdsbcn_4)
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2,MD)
})
library(BGLR,lib.loc="/genetics/bin/R")
E <- list(FIXED=list(X=X, model='FIXED'),g=list(K=GRM, model='RKHS'),
          ge=list(K=mdGRM, model='RKHS'))
m <- BGLR(y=y, ETA=E, df0=3, S0=4, nIter=100000, burnIn=10000, thin=1, saveAt='MD_')
save(m,file='MD.fit')
