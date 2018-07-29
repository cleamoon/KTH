function out = observing()
global pos Mobs lost elast nn ft States t;
txy = loc(pos(4,:));
res = (Mobs(txy(1), txy(2)) == 1);
if res
    ft = false;
    lost = false;
else
    if ~lost
        elast = small2big([States(nn*2+1, t-1), States(nn*2+2, t-1)]);
        lost = true;
    end
end
out = res;