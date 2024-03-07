# 8-5-2018 JHZ

library(foreign)
sc <- read.csv("map.csv")
library(RgoogleMaps)
map <- GetMap(center="Europe",zoom=4)
library(ggmap)
map <- get_map(location="europe",zoom=4)
cp <- ggmap(map)+geom_point(aes(x=lon, y=lat, size=N), data=sc, alpha=.5, color="red")
png("ggmap.png",height=7,width=7,units="in",res=300)
plot(cp)
dev.off()
