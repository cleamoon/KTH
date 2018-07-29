function res = trans(q, p, ll, ru) 
global ne;
d = q - p;
phi = atan(d(2)/d(1));
a = norm(distance2rectangle(q, p, ll, ru)-p);
b = norm(distance2rectangle(q, p, [1,1], [ne, ne])-p)-a;
if norm(d) > 1e-8
    res = (norm(d)-a)*d/norm(d)*(a+b)/b + p;
else
    res = ru+[1, 1];
end