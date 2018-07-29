%% minimum phase part
sysmp = minphase;
pole(sysmp);
tzero(sysmp);
smatrix = ssdata(sysmp);
stransf = tfdata(sysmp);
ninf = hinfnorm(sysmp);
[U,S,V] = svd(smatrix);
