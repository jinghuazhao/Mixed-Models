#19-4-2012 MRC-Epid JHZ

library(regress)
library("MASS")
set.seed(12345)
n <- 500
m <- c(1,2,3)
S <- matrix(c(10,1,2, 1,20,3, 2,3,50),3,3)
Y <- mvrnorm(n,m,S)
y <- as.vector(t(Y))
c <- kronecker(rep(1,n),diag(1,3))
V1 <- matrix(c(1,0,0, 0,0,0, 0,0,0),3,3,byrow=TRUE)
V2 <- matrix(c(0,1,0, 1,0,0, 0,0,0),3,3,byrow=TRUE)
V3 <- matrix(c(0,0,0, 0,1,0, 0,0,0),3,3,byrow=TRUE)
V4 <- matrix(c(0,0,1, 0,0,0, 1,0,0),3,3,byrow=TRUE)
V5 <- matrix(c(0,0,0, 0,0,1, 0,1,0),3,3,byrow=TRUE)
V6 <- matrix(c(0,0,0, 0,0,0, 0,0,1),3,3,byrow=TRUE)
id <- as.vector(t(cbind(1:n,1:n,1:n)))
s1 <- kronecker(diag(1,n),V1)
s2 <- kronecker(diag(1,n),V2)
s3 <- kronecker(diag(1,n),V3)
s4 <- kronecker(diag(1,n),V4)
s5 <- kronecker(diag(1,n),V5)
s6 <- kronecker(diag(1,n),V6)

results <- regress(y~c-1,~s1+s2+s3+s4+s5+s6,pos=c(1,0,1,0,0,1),identity=FALSE,start=c(10,1,20,1,1,30))
results
apply(Y,2,mean)
cov(Y)

dimnames(s1)[[1]] <- dimnames(s1)[[2]] <- id
dimnames(s2)[[1]] <- dimnames(s2)[[2]] <- id
dimnames(s3)[[1]] <- dimnames(s3)[[2]] <- id
dimnames(s4)[[1]] <- dimnames(s4)[[2]] <- id
dimnames(s5)[[1]] <- dimnames(s5)[[2]] <- id
dimnames(s6)[[1]] <- dimnames(s6)[[2]] <- id

ps1 <- cbind(id,1,s1)
ps2 <- cbind(id,2,s2)
ps3 <- cbind(id,3,s3)
ps4 <- cbind(id,4,s4)
ps5 <- cbind(id,5,s5)
ps6 <- cbind(id,6,s6)
con <- rep(1:3,n)
write.table(data.frame(cbind(id,con,y,c)),file="mv.dat",quote=FALSE,col.names=FALSE,row.names=FALSE)
ldata <- data.frame(rbind(ps1,ps2,ps3,ps4,ps5,ps6))
write.table(ldata,file="mv_ldata.dat",quote=FALSE,col.names=FALSE,row.names=FALSE)

library(kinship)
lmekin(y~c-1,random=~1|id,varlist=list(s1,s2,s3,s4,s5,s6))
