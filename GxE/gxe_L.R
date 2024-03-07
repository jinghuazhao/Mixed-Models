#$ -S /usr/local/bin/Rscript
#$ -N gxe_L
#$ -cwd
#$ -o gxe_L.o
#$ -e gxe_L.e
#$ -pe make 5
#$ -q all.q

# 12-5-2018 JHZ

.libPaths("/genetics/bin/R")
library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
# GRM <- GRM/mean(diag(GRM))
paGRM <- with(ReadGRMBin("PA"),GRM)
bmiGRM <- with(ReadGRMBin("BMI"),GRM)
mdGRM <- with(ReadGRMBin("MD"),GRM)
L_GRM <- t(chol(GRM))
L_PA <- t(chol(paGRM))
L_BMI <- t(chol(bmiGRM))
L_MD <- t(chol(mdGRM))
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   PA <- as.numeric(pa_index_4)
   BMI <- as.numeric(bmi_adj_4)
   MD <- as.numeric(mdsbcn_4)
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2,PA,BMI,MD)
})
library(BGLR)
E <- list(FIXED=list(X=X, model='FIXED'),g=list(X=L_GRM,model='BRR'),
          ge1=list(X=L_BMI,model='BRR'),
          ge2=list(X=L_PA,model='BRR'),
          ge3=list(X=L_MD,model='BRR'))
m <- BGLR(y=y, ETA=E, nIter=100000, burnIn=10000, thin=1, saveAt='gxe_L_')
save(m,file='gxe_L.fit')
