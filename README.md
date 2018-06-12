# MixedModels

**Mixed models with polygenci effects**

This repository contains information on several aspects (**in individual directories**) of the models:

1. [Mixed Modeling with Whole Genome Data](JPS/jps.pdf) (**[JPS](JPS)**) provides an overview and is 
derived from work on analysis of data in famniles where relationship between relatives is customarily 
considered yet only recently mirrored in population-based samples for which a genomic relationship matrix 
(GRM) is built from genomewide data. The work was motivated by the S-Plus package kinship developed at the 
Mayo Clinic, ported to R for genetic analysis workshop 14 (GAW14) and later reported in [a 
paper](https://bmcgenet.biomedcentral.com/articles/10.1186/1471-2156-6-S1-S127) in 2005.

2. [Bayesian Linear Mixed Model with Polygenic Effects](JSS/paper.pdf) (**[JSS](JSS)**) extends work 
reported in the above paper to the Bayesian framework, incorporating a variety of implementations often 
seen in literature for general statistics besides specialised software initially developed for plant 
genetics.

3. Additional aspect (**[GxE](GxE)**) focuses on study of GxE interaction via frequentist and Bayesian 
approaches.

The issues and their solutions are generic and have implications in assessing SNP-trait association 
including prediction and Mendelian randomisation analysis, given that increasing number of variants are
identified with between-popuation fluctuations. These variants are often collectively used for these
purposes via polygenic risk scores.
