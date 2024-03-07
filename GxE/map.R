# 8-5-2018 MRC-Epid JHZ

l1 <- read.csv("ll")
l2 <- read.csv("ll.out")
l <- cbind(l1[,-1],l2[,-4])
la <- lm(lat~lat_centre,data=l,na.action=na.exclude)
lo <- lm(lon~long_centre,data=l,na.action=na.exclude)
l <- within(l, {
  lat[c(2,3,6)] <- predict(la,data.frame(lat_centre=lat_centre[c(2,3,6)]))
  lon[c(2,3,6)] <- predict(lo,data.frame(long_centre=long_centre[c(2,3,6)]))
# N <- c(212, 163, 186, 132, 100, 74, 931, 601, 597, 858, 406, 1287, 815, 1264, 1286, 1237, 1747, 577, 879, 1411, 1618, 1960, 3556, 1845, 1265, 2772)
  N <- c(44, 47, 41, 23, 31, 33, 414, 253, 73, 417, 60, 139, 406, 609, 512, 275, 673, 204, 354, 656, 708, 958, 1329, 835, 1154, 2409)
})
write.csv(l,file="map.csv")

library(maps)
library(mapdata)
data(world.cites)
country <- c("France","Italy","Spain","UK","Netherlands","Greece","Germany","Sweden","Denmark")
caps <- subset(world.cities,country.etc%in%country&capital==1)

with(l[-(25:26),],{
  png("map.png",width=7,height=7,res=300,units="in")
  map('world', country)
# map.text('world',country)
  with(caps, {
    points(long,lat,col=14,pch=20)
    text(long,lat+0.5,name,cex=0.5,col="red")
  })
  text(lon,lat,letters[-(25:26)],cex=0.5,col="blue")
  xlim <- range(lon)
  ylim <- range(lat)
  dev.off()
})
with(l[-(25:26),],paste(letters[-(25:26)],"-",centre))

