# 2-12-2015 MRC-Epid JHZ

library(foreign)
gcta <- read.dta("gcta.dta")
png("corr.png",width=8,height=8,res=300,units="in")
with(gcta, {
    BMI <- bmi_adj
    PA <- pa_index
    MD <- mdsbcn
    SSB <- qge1302sw
    pairs(cbind(age,BMI,PA,MD,SSB),cex=0.15)
})
dev.off()
