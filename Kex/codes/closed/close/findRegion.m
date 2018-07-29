function [ll, ru, p, x0, y0, x1, y1] = findRegion(q)
global region regionobs;
for i = 1:4
    [x0, y0, x1, y1] = deal(region(i, 1), region(i, 2), region(i, 3), region(i, 4));
    if q(1) >= x0 && q(1) <= x1 && q(2) >= y0 && q(2) <= y1
        ll = [regionobs(i, 1), regionobs(i, 2)];
        ru = [regionobs(i, 3), regionobs(i, 4)];
        p = (ll+ru)/2;
        break;
    end
end