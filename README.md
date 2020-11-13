# Mixed-Models

**Mixed models with polygenic effects**

The repository is motivated from a contribution to genetic analysis workshop 14 (GAW14).

Several aspects (**in subdirectories**) of the models are exposed,

1. Mixed modeling with whole genome data (**[JPS](JPS)**) provides an overview and is derived from work on analysis of family data where relationship between relatives is commonly 
used and recently mirrored in population-based samples with a genomic relationship matrix (GRM) from whole genome genotypes.

2. Bayesian linear mixed model with polygenic effects (**[JSS](JSS)**) adds Bayesian implementation using software such as [OpenBUGS](http://openbugs.net/w/FrontPage), 
[JAGS](http://mcmc-jags.sourceforge.net/) and [Stan](http://mc-stan.org/) plus specialised software.

3. GxE interaction (**[GxE](GxE)**) is considered via both frequentist and Bayesian approaches above.

They have generic implications in assessment of SNP-trait association including risk prediction and Mendelian randomisation analysis, given that increasing number of variants are 
identified but with inter-popuation fluctuations. These variants are often used collectively as polygenic risk scores.

## Exposition

This regards p values during analysis of BiSeq data, as it is shown here, [https://github.com/jinghuazhao/QTR](https://github.com/jinghuazhao/QTR).

## EnvWAS

This is associated with the CLARITE package, R package (https://github.com/HallLab/clarite), Python package (https://github.com/HallLab/clarite-python and https://halllab.github.io/clarite-python/) with index (https://pypi.org/).

## References

Asar O, Bolin D, Diggle PJ, Wallin J (2018). Linear Mixed-effects models for non-Gaussian repeated measurement data. arXiv:1804.02592, https://arxiv.org/abs/1804.02592

Casale FP (2016). Multivariate linear mixed models for statistical genetics (Doctoral thesis). https://doi.org/10.17863/CAM.13422.

Gad AM, EL-Zayat, NI (2018). Fitting Multivariate Linear Mixed Model for Multiple Outcomes Longitudinal Data with Non-ignorable Dropout. *International Journal of Probability and Statistics*, 7(4): 97-105, DOI: 10.5923/j.ijps.20180704.01

Lucas AM, Palmiero NE, Orie D, Ritchie MD, Hall MA (2019). CLARITE facilitates the quality control and analysis process for EWAS of metabolic-related traits . *Frontiers in Genetics* 10:01240. doi: 10.3389/fgene.2019.01240

Zhao JH (2005). [Mixed-effects Cox models of alcohol dependence in extended families](https://doi.org/10.1186/1471-2156-6-S1-S127), *BMC Genetics* 6 (Suppl 1):S127.

Zhao JH, Luan JA (2012). [Mixed modeling with whole genome data](https://www.hindawi.com/journals/jps/2012/485174/). *Journal of Probability and Statistics*, Volume 2012, 1-16.

Zhao JH, Luan JA, Congdon P (2018). [Bayesian linear mixed models with polygenic effects](https://www.jstatsoft.org/article/view/v085i06). *Journal of Statistical Software* 85(6).

Zhao JH, Scott R, Luan JA, Sharp S, Langenberg C, Wareham NJ (2018). Polygenic and interaction effects in Type-2 diabetes – The InterAct study (unpublished manuscript).
