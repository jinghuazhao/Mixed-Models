pheno <- read.table("p.dat", col.names = c("pid", "id", "r"))
N <- nrow(pheno)
trios <- read.table("trios.dat", header = TRUE)
is.na(trios[trios == 0]) <- TRUE
f <- merge(pheno, trios[, -1], by = "id", all = TRUE)
p <- data.frame(f[with(f, order(pid, id)), ], u = seq_len(N), e = seq_len(N))
rownames(p) <- seq_len(N)
save(p, file = "p.rda")
