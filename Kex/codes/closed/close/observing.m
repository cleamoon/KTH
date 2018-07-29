function res = observing()
global exy Mobsp;
setObservableRegion(1);
txy = loc(exy);
res = (Mobsp(txy(1), txy(2)) == 1);