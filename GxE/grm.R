# 18-5-2018 JHZ

library(readstata13)
d <- within(read.dta13("gxe.dta"), {
   lat_centre <- lat_centre/1000
   long_centre <- long_centre/1000
   z <- 0
})
library(dummies)
v <- c("bmi_adj_4","pa_index_4","mdsbcn_4")
dd <- dummy.data.frame(d,v)
library(gap)
GRMBin <- ReadGRMBin("gcta/test/gcta", AllN = TRUE)
dowrite <- function(vec,f) with(GRMBin,{
   v <- as.numeric(vec)
   vv <- outer(v, v, '-')
   gxe <- (1-abs(vv/3)) * GRM
   grm <- gxe[upper.tri(gxe, diag = TRUE)]
   WriteGRMBin(f,grm,N,id)
})
with(data.frame(dd,d[v]), {
    r <- exp(-dist(cbind(lat_centre,long_centre)))
    with(GRMBin, WriteGRMBin("r",r[upper.tri(r,diag=TRUE)], N, id))
    dowrite(bmi_adj_4,"BMI")
    dowrite(pa_index_4,"PA")
    dowrite(mdsbcn_4,"MD")
})
