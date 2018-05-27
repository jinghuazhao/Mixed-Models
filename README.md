# BLMM-PE

Information for [the paper to appear](2367.zip) on [*J Stat Soft*](https://www.jstatsoft.org/index), particularly the GRM and the [BLR log](BLR.zip) and [1,000 bootstrap log](boot.zip) for the [GCTA](http://cnsgenomics.com/software/gcta/) documentation example.

Once the repository is downloaded, the GRM.grm.gz can be reassembled via the following command,
```
zcat GRM.grm-{0..4}.gz | gzip -cf > GRM.grm.gz
```
where GRM.grm-{0..4} were originally generated from,
```
export N=$(($(gunzip -c GRM.grm.gz | wc -l)/5+1))
gunzip < GRM.grm.gz | split - --lines=$N --numeric-suffixes --suffix-length=1 GRM.grm-
gzip GRM.grm-*
```

The Sweave version is [jss2367.rar](jss2367.rar), whose format is described at [https://rarlab.com/](https://rarlab.com/).
