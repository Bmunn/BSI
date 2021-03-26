function [nrgLCdt,nrgBNMdt,nrgBasedt] = lcBnmPdistn(msdLC,msdBNM,msdBase)

dat = msdLC;
pd = fitdist(dat,'Kernel','BandWidth',4);
yLC = pdf(pd,ds);
nrgLCdt = -1.*log(yLC);


dat = msdBNM;
pd = fitdist(dat,'Kernel','BandWidth',4);
yBNM = pdf(pd,ds);
nrgBNMdt = -1.*log(yBNM);


dat = msdBase;
pd = fitdist(dat,'Kernel','BandWidth',4);
yBase = pdf(pd,ds);
nrgBasedt = -1.*log(yBase);


end