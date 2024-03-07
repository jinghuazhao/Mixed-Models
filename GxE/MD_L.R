#$ -S /usr/local/bin/Rscript
#$ -N MD_L
#$ -cwd
#$ -o MD_L.o
#$ -e MD_L.e
#$ -pe make 5
#$ -q all.q

# 13-5-2018 JHZ

.libPaths("/genetics/bin/R")
library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
# GRM <- GRM/mean(diag(GRM))
mdGRM <- with(ReadGRMBin("MD"),GRM)
L_GRM <- t(chol(GRM))
L_MD <- t(chol(mdGRM))
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   MD <- as.numeric(mdsbcn_4)
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2,MD)
})
library(BGLR)
E <- list(FIXED=list(X=X, model='FIXED'),g=list(X=L_GRM,model='BRR'),
          ge=list(X=L_MD,model='BRR'))
m <- BGLR(y=y, ETA=E, nIter=150000, burnIn=10000, thin=1, saveAt='MD_L_')
save(m,file='MD_L.fit')
