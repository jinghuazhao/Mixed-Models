#$ -S /usr/local/bin/Rscript
#$ -N BMI
#$ -cwd
#$ -o BMI.o
#$ -e BMI.e
#$ -pe make 5
#$ -q all.q

# 10-5-2018 JHZ

library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
# GRM <- GRM/mean(diag(GRM))
bmiGRM <- with(ReadGRMBin("BMI"),GRM)
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   BMI <- as.numeric(bmi_adj_4)
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2,BMI)
})
library(BGLR,lib.loc="/genetics/bin/R")
E <- list(FIXED=list(X=X, model='FIXED'),g=list(K=GRM, model='RKHS'),
          ge=list(K=bmiGRM, model='RKHS'))
m <- BGLR(y=y, ETA=E, df0=3, S0=4, nIter=100000, burnIn=10000, thin=1, saveAt='BMI_')
save(m,file='BMI.fit')
