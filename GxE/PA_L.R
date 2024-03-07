#$ -S /usr/local/bin/Rscript
#$ -N PA_L
#$ -cwd
#$ -o PA_L.o
#$ -e PA_L.e
#$ -pe make 5
#$ -q all.q

# 13-5-2018 JHZ

.libPaths("/genetics/bin/R")
library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
# GRM <- GRM/mean(diag(GRM))
paGRM <- with(ReadGRMBin("PA"),GRM)
L_GRM <- t(chol(GRM))
L_PA <- t(chol(paGRM))
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   PA <- as.numeric(pa_index_4)
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2,PA)
})
library(BGLR)
E <- list(FIXED=list(X=X, model='FIXED'),g=list(X=L_GRM,model='BRR'),
          ge=list(X=L_PA,model='BRR'))
m <- BGLR(y=y, ETA=E, nIter=150000, burnIn=10000, thin=1, saveAt='PA_L_')
save(m,file='PA_L.fit')
