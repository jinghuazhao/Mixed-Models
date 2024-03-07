#$ -S /usr/local/bin/Rscript
#$ -N gxe
#$ -cwd
#$ -o gxe.o
#$ -e gxe.e
#$ -pe make 5
#$ -q all.q

# 10-5-2018 JHZ

library(gap)
GRM <- with(ReadGRMBin("gcta/test/gcta"),GRM)
# GRM <- GRM/mean(diag(GRM))
paGRM <- with(ReadGRMBin("PA"),GRM)
bmiGRM <- with(ReadGRMBin("BMI"),GRM)
mdGRM <- with(ReadGRMBin("MD"),GRM)
library(readstata13)
with(read.dta13("gxe.dta"), {
   y <<- diabetes_status
   PA <- as.numeric(pa_index_4)
   BMI <- as.numeric(bmi_adj_4)
   MD <- as.numeric(mdsbcn_4)
   X <<- cbind(sex,age,corex_combined_c1,corex_combined_c2,PA,BMI,MD)
})
library(BGLR)
E <- list(FIXED=list(X=X, model='FIXED'),g=list(K=GRM, model='RKHS'),
          ge1=list(K=paGRM, model="RKHS"),
          ge2=list(K=bmiGRM, model="RKHS"),
          ge3=list(K=mdGRM, model="RKHS"))
m <- BGLR(y=y, ETA=E, df0=3, S0=4, nIter=100000, burnIn=10000, thin=1, saveAt='gxe_')
save(m,file='gxe.fit')
