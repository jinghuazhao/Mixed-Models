Information for [the manuscript](paper.pdf) and [the paper](https://www.jstatsoft.org/article/view/v085i06).

File | Description
-----|-------------------------------------------------
paper.*, Figures/, Code/, ref.bib | JSS paper
GRM.grm.id, GRM.grm-*.gz | GRM ID and partitioned files
jss2367.rar | Sweave version
BLR.zip, boot.zip | [GCTA](http://cnsgenomics.com/software/gcta/) documentation example

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

**rar**

The format of Sweave version [jss2367.rar](jss2367.rar) is described at [https://rarlab.com/](https://rarlab.com/).
