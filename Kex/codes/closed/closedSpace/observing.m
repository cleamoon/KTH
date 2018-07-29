function res = observing()
global exy Mobsp ne;
lx = min(max(floor(exy(1))+1, 1), ne);
ly = min(max(floor(exy(2))+1, 1), ne);
if Mobsp(lx, ly) == 1
    res = true;
else
    res = false;
end