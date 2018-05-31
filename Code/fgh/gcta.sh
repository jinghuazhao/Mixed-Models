## genetic relationship matrix

R --no-save -q <<END
trios <- read.table("trios.dat", header = TRUE)
library("kinship2")
kmat <- with(trios, kinship(id, fid, mid))
id <- trios[c("pid", "id")]
N <- dim(trios)[1]
M <- rep(N, N * (N + 1) / 2)
library("gap")
WriteGRM("PRM", id, M,  2 * kmat)
END

## heritability estimation

gcta64 --reml --grm-gz PRM --pheno p.dat --out PRM --thread-num 10
gcta64 --reml --grm-gz GRM --pheno p.dat --out GRM --thread-num 10
