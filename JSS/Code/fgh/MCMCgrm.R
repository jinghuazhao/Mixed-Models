p <- read.table("p.dat", col.names = c("pid", "id", "r"))
trios <- read.table("trios.dat", header = TRUE)
library("kinship2")
kmat <- with(trios, kinship(id, fid, mid))
N <- dim(trios)[1]
M <- rep(N, N * (N + 1) / 2)
library("gap")
K <- as.matrix(kmat) * 2
library("gap")
g <- ReadGRM("GRM")
G <- g$GRM

model <- "r ~ 1"
prior <- list(R = list(V = 1, nu = 0.002), G = list(G1 = list(V = 1, nu = 0.002)))
m1 <- MCMCgrm(model, prior, p, K, n.burnin = 300, n.iter = 1000)
m2 <- MCMCgrm(model, prior, p, G, eps = 0.1, n.burnin = 300, n.iter = 1000)
save(m1, m2, file = "MCMCgrm.fit")
m1
m2
