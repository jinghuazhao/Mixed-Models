# 13/5/2018 JHZ

L <- function(h2,step=10)
{
  require(gap)
  f <- gl(as.integer(length(h2)/step),step)
  h2split <- split(h2,f)
  m <- unlist(lapply(h2split,mean))
  s <- unlist(lapply(h2split,sd))
  hl <- h2l(K=0.05,P=P,h2=m,se=s,verbose=FALSE)$h2l
  r <- as.mcmc(hl)
  print(summary(r))
  print(HPDinterval(r))
}

K <- 0.05
burnIn <- 10000
load_fit <- FALSE

# 0.4111
P <- 5203/12657

## g

for(M in c("g","BLR"))
{
   cat("\n",M,"\n")
   if (load_fit)
   {
      load("g.fit")
      attach(m)
      fit
      varU <- ETA$g$varU
      varU/(varU+varE)
      detach(m) 
   }
   g <- scan(paste0(M,ifelse(M=="g","_ETA_g",""),"_varU.dat"),skip=burnIn)
   e <- scan(paste0(M,"_varE.dat"),skip=burnIn)
   h2 <- g/(g+e)
   library(coda)
   r <- as.mcmc(cbind(g,e,h2))
   print(summary(r))
   print(HPDinterval(r))
   png(paste0(M,".png"),height=15,width=15,units="cm",res=300)
   plot(r)
   dev.off()
   L(h2)
}

library(coda)
for(E in c("BMI","PA","MD"))
{
  cat("\n",E,"\n")
  if (load_fit)
  {
     load(paste0(e,".fit"))
     attach(m)
     fit
     varU <- ETA$g$varU + ETA$ge$varU
     cat("h2=",varU/(varU+varE),"\n")
     detach(m)
  }
  g <- scan(paste0(E,"_ETA_g_varU.dat"),skip=burnIn)
  ge <- scan(paste0(E,"_ETA_ge_varU.dat"),skip=burnIn)
  e <- scan(paste0(E,"_varE.dat"),skip=burnIn)
  h2 <- g/(g+ge+e)
  h2ge <- ge/(g+ge+e)
  H2 <- h2+h2ge
  v <- as.mcmc(cbind(g,ge,e))
  png(paste0(E,"-v.png"),height=15,width=15,units="cm",res=300)
  plot(v)
  dev.off()
  h <- as.mcmc(cbind(h2,h2ge,H2))
  png(paste0(E,"-h2.png"),height=15,width=15,units="cm",res=300)
  plot(h)
  dev.off()
  r <- as.mcmc(cbind(g,ge,e,h2,h2ge,H2))
  print(summary(r))
  print(HPDinterval(r))
  L(h2)
  L(h2ge)
  L(H2)
}

## all e's

for (prefix in c("gxe","gxe_L"))
{
   cat("\n",prefix,"\n")
   suffix <- ifelse(prefix=="gxe_L","B","U")
   g <- scan(paste0(prefix,"_ETA_g_var",suffix,".dat"),skip=burnIn)
   ge1 <- scan(paste0(prefix,"_ETA_ge1_var",suffix,".dat"),skip=burnIn)
   ge2 <- scan(paste0(prefix,"_ETA_ge2_var",suffix,".dat"),skip=burnIn)
   ge3 <- scan(paste0(prefix,"_ETA_ge3_var",suffix,".dat"),skip=burnIn)
   ge <- ge1+ge2+ge3
   e <- scan(paste0(prefix,"_varE.dat"),skip=burnIn)
   h2 <- g/(g+ge+e)
   h2ge1 <- ge1/(g+ge+e)
   h2ge2 <- ge2/(g+ge+e)
   h2ge3 <- ge3/(g+ge+e)
   h2ge <- ge/(g+ge+e)
   H2 <- h2+h2ge
   library(coda)
   v <- as.mcmc(cbind(g,ge,e))
   h <- as.mcmc(cbind(h2,h2ge,H2))
   hge <- as.mcmc(cbind(h2ge1,h2ge2,h2ge3))
   r <- as.mcmc(cbind(g,ge,e,h2ge1,h2ge2,h2ge3,h2,h2ge,H2))
   print(summary(r))
   print(HPDinterval(r))
   pdf(paste0(prefix,".pdf"))
   plot(v)
   plot(h)
   plot(hge)
   dev.off()
   L(h2)
   L(h2ge1)
   L(h2ge2)
   L(h2ge3)
   L(h2ge)
   L(H2)
}

