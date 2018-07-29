function res = small2big(q) 
[ll, ru, p, x0, y0, x1, y1] = findRegion(q);
d = q - p;
a = norm(distance2rectangle(q, p, ll, ru)-p);
b = norm(distance2rectangle(q, p, [x0, y0], [x1, y1])-p)-a;
res = (norm(d)-a)*d/norm(d)*(a+b)/b + p;
