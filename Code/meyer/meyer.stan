/*5-5-2015 MRC-Epid JHZ */

data {
  int N;
  vector[N] y;
  vector[N] g1;
  vector[N] g2;
  matrix[N,N] G;
}
transformed data {
  matrix[N,N] C;
  C <- cholesky_decompose(G);
}
parameters {
  vector[2] b;
  vector[N] z;
  real sigma_p2;
  real sigma_r2;
}
transformed parameters {
  real sigma_p;
  real sigma_r;
  vector[N] g;
  sigma_p <- sqrt(sigma_p2);
  sigma_r <- sqrt(sigma_r2);
  g <- sigma_p * C * z;
}
model {
  b ~ normal(0, 1000);
  sigma_p2 ~ inv_gamma(0.001,0.001);
  sigma_r2 ~ inv_gamma(0.001,0.001);
  z ~ normal(0,1);
  y ~ normal(b[1] * g1 + b[2] * g2 + g,sigma_r);
}
generated quantities {
  real h2;
  real p;
  real r;
  p <- sigma_p2;
  r <- sigma_r2;
  h2 <- p / (p + r);
}
