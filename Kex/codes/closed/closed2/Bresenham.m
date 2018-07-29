function Bresenham (p0, p1)
global M Mobs ne;
[x0, y0] = deal(p0(1), p0(2));
[x1, y1] = deal(p1(1), p1(2));
steep = abs(y1 - y0) > abs(x1 - x0);
if steep
    [x0, y0] = deal(y0, x0);
    [x1, y1] = deal(y1, x1);
end
reverse = x0 > x1;
if reverse
    [x0, x1] = deal(x1, x0);
    [y0, y1] = deal(y1, y0);
end
[deltax, deltay, error, y] = deal(x1-x0, abs(y1-y0), 0, y0);
deltaerr = deltay / deltax;
if y0 < y1 
    ystep = 1;
else
    ystep = -1;
end
l = zeros(ne*2, 2);
nn = 1;
for x = x0:1:x1
    if steep
        l(nn, :) = [y, x];
    else
        l(nn, :) = [x, y];
    end
    [nn, error] = deal(nn+1, error + deltaerr);
    if error >= 0.5 
        [y, error] = deal(y + ystep, error - 1.0);
    end
    if (y<1) || (y>ne)
        break;
    end
end
if ~reverse
    lc = 1:nn-1;
else
    lc = nn-1:-1:1;
end
for i = 1:nn-1
    if M(l(lc(i),1), l(lc(i),2)) == 1
        return;
    else
        Mobs(l(lc(i),1), l(lc(i),2)) = 1;
    end
end