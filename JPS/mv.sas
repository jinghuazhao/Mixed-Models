/*20-4-2012 MRC-Epid JHZ*/

options nocenter ps=max ls=max;
libname x '.';
data mv;
     infile 'mv.dat';
     input id con q c1-c3;
run;
data mv_ldata;
     infile 'mv_ldata.dat' lrecl=50000;
     input id parm col1-col1500 ;
run;
proc sort data=mv_ldata;
     by parm;
run;
data x.mv_ldata mv_ldata;
     set mv_ldata;
     by parm;
     retain row;
     if first.parm then row=1;
     else row+1;
run;
proc mixed data=mv covtest asycov noclprint;
     class id con;
     model q= con / noint solution;
     random con*id / type=lin(6) ldata=x.mv_ldata;
run;
/*
     parms (1)(-1)(2)(-1)(-1)(3)(1)/ lowerb=1e-4,.,1e-4,.,.,1e-4;
*/
