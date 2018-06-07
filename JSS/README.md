Information for [the paper](paper.pdf) to appear on [*J Stat Soft*](https://www.jstatsoft.org/index), the [GCTA](http://cnsgenomics.com/software/gcta/) documentation example.

File | Description
-----|-----------------------------------------
paper.* Figures Code ref.bib | JSS paper
GRM.grm.id GRM.grm-*.gz | GRM
jss2367.rar | Sweave version
BLR.zip boot.zip | GCTA documentation example

**GRM**

Once the repository is cloned, the GRM.grm.gz can be reassembled via the following command,
```
zcat GRM.grm-{0..4}.gz | gzip -cf > GRM.grm.gz
```
where GRM.grm-{0..4} were originally generated from,
```
export N=$(($(gunzip -c GRM.grm.gz | wc -l)/5+1))
gunzip < GRM.grm.gz | split - --lines=$N --numeric-suffixes --suffix-length=1 GRM.grm-
gzip GRM.grm-*
```

**rar***

The rar format of Sweave version [jss2367.rar](jss2367.rar), is described at [https://rarlab.com/](https://rarlab.com/).

