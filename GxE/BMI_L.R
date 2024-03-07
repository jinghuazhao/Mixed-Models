#$ -S /usr/local/bin/Rscript
#$ -N BMI_L
#$ -cwd
#$ -o BMI_L.o
#$ -e BMI_L.e
#$ -pe make 5
#$ -q all.q

# 13-5-2018 JHZ

.libPaths("/genetics/bin/R")
library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
# GRM <- GRM/mean(diag(GRM))
bmiGRM <- with(ReadGRMBin("BMI"),GRM)
L_GRM <- t(chol(GRM))
L_BMI <- t(chol(bmiGRM))
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   BMI <- as.numeric(bmi_adj_4)
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2,BMI)
})
library(BGLR)
E <- list(FIXED=list(X=X, model='FIXED'),g=list(X=L_GRM,model='BRR'),
          ge=list(X=L_BMI,model='BRR'))
m <- BGLR(y=y, ETA=E, nIter=150000, burnIn=10000, thin=1, saveAt='BMI_L_')
save(m,file='BMI_L.fit')
