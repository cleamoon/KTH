function res = gauss2d(f, x1, x2, y1, y2)
res = 0;
m = 10;
dx = (x2-x1)/m;
dy = (y2-y1)/m;
for i = 1:m
    for j = 1:m
        xm = x1+dx*i-dx/2;
        ym = y1+dy*j-dy/2;
        dxi = dx/4/sqrt(3);
        dyi = dy/4/sqrt(3);
        res = res + dx*dy/4*(f(xm+dxi, ym+dyi) + f(xm+dxi, ym-dyi) + f(xm-dxi, ym+dyi) + f(xm-dxi, ym-dyi));
    end
end
