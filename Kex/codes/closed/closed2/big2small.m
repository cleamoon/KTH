function res = big2small(q)
[ll, ru, p, x0, y0, x1, y1] = findRegion(q);
d = q - p;
a = norm(distance2rectangle(q, p, ll, ru)-p);
b = norm(distance2rectangle(q, p, [x0, y0], [x1, y1])-p)-a;
res = (a + norm(d)*b/(a+b))*d/norm(d) + p;
