# MixedModels

Mixed models with polygenci effects

This repository contains information on aspects of the modeling in three directories,

1. **[JPS](JPS)**. [Mixed Modeling with Whole Genome Data](JPS/jps.pdf)
provides an overview and is derived from work on analysis of data in famniles where relationship between
relatives is customarily considered yet only recently mirrored in population-based samples for which a
genomic relationship matrix (GRM) is built from genomewide data. The work was motivated by the S-Plus package
kinship developed at the Mayo Clinic, ported to R for genetic analysis workshop 14 (GAW14) and later reported
in [a paper](https://bmcgenet.biomedcentral.com/articles/10.1186/1471-2156-6-S1-S127) in 2005.

2. **[JSS](JSS)**. [Bayesian Linear Mixed Model with Polygenic Effects](JSS/paper.pdf)
extends work reported in the above paper to the Bayesian framework, incorporating a variety of implementations
often seen in literature for general statistics besides specialised software initially developed for plant genetics.

3. **[GxE](GxE)**. An analysis utilises both frequentist and Bayesian approaches to the study of GxE interaction.

These aspects are generic and have implications in assessing SNP-trait association as well as prediction, given
increasing number of variants are identified and between-popuation variation is observed. These variants
traditionally relate to polygenic risk score and Mendelian randomisation analysis.
