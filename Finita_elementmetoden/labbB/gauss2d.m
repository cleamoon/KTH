function res = gauss2d(f, x1, x2, y1, y2)
res = 0;
m = 30;
dx = (x2-x1)/m;
dy = (y2-y1)/m;
for i = 1:m
    for j = 1:m
        xm = x1+dx*i-dx/2;
        ym = y1+dy*j-dy/2;
        dxi = dx/2/sqrt(5)*sqrt(3);
        dyi = dy/2/sqrt(5)*sqrt(3);
        res = res + dx*dy/4*(25/81*f(xm-dxi, ym-dyi) + 40/81*f(xm, ym-dyi) + 25/81*f(xm+dxi, ym-dyi) + 40/81*f(xm-dxi, ym) + 64/81*f(xm, ym) + 40/81*f(xm+dxi, ym) + 25/81*f(xm-dxi, ym+dyi) + 40/81*f(xm, ym+dyi) + 25/81*f(xm+dxi, ym+dyi));
    end
end
