# Mixed-Models

**Mixed models with polygenic effects**

The repository is motivated from the following contribution to genetic analysis workshop 14 (GAW14).

Several aspects (**in subdirectories**) of the models are exposed,

1. Mixed modeling with whole genome data (**[JPS](JPS)**) provides an overview and is derived from work on analysis of family data where relationship between relatives is commonly 
used and recently mirrored in population-based samples with a genomic relationship matrix (GRM) from whole genome genotypes.

2. Bayesian linear mixed model with polygenic effects (**[JSS](JSS)**) adds Bayesian implementation using software such as [OpenBUGS](http://openbugs.net/w/FrontPage), 
[JAGS](http://mcmc-jags.sourceforge.net/) and [Stan](http://mc-stan.org/) plus specialised software.

3. GxE interaction (**[GxE](GxE)**) is considered via both frequentist and Bayesian approaches above.

They have generic implications in assessment of SNP-trait association including risk prediction and Mendelian randomisation analysis, given that increasing number of variants are 
identified but with inter-popuation fluctuations. These variants are often used collectively as polygenic risk scores.

## References

Zhao JH (2005). [Mixed-effects Cox models of alcohol dependence in extended families](https://doi.org/10.1186/1471-2156-6-S1-S127), *BMC Genetics* 6 (Suppl 1):S127.

Zhao JH, Luan JA (2012). Mixed modeling with whole genome data. *Journal of Probability and Statistics*, Volume 2012, 1-16, http://dx.doi.org/10.1155/2012/485174

Zhao JH, Luan JA, Congdon P (2018). [Bayesian linear mixed models with polygenic effects](https://www.jstatsoft.org/article/view/v085i06). *Journal of Statistical Software* 85(6).

Zhao JH, Scott R, Luan JA, Sharp S, Langenberg C, Wareham NJ (2018). Polygenic and interaction effects in Type-2 diabetes – The InterAct study (Unpublished manuscript).



