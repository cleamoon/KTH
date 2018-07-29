function res = distance2rectangle(q, p, ll, ru)
d = q - p;
if abs(d(1)) > 1e-8
    k = d(2)/d(1);
else
    if q(2) > p(2)
        res = [p(1), ru(2)];
        return;
    else
        res = [p(1), ll(2)];
        return;
    end
end
if norm(d) < 1e-8
    res = q;
    return;
end
dd = d/norm(d);
ly = k*ll(1) + (p(2)-p(1)*k);
pd = ([ll(1), ly] - p)/norm([ll(1), ly] - p);
if (ly <= ru(2)) && (ly >= ll(2)) && norm(dd-pd)<1e-9
    res = [ll(1), ly];
    return;
end
ly = k*ru(1) + (p(2)-p(1)*k);
pd = ([ru(1), ly] - p)/norm([ru(1), ly] - p);
if (ly <= ru(2)) && (ly >= ll(2)) && norm(dd-pd)<1e-9 
    res = [ru(1), ly];
    return;
end
lx = (ll(2)-(p(2)-p(1)*k))/k;
pd = ([lx, ll(2)] - p)/norm([lx, ll(2)] - p);
if (lx <= ru(1)) && (lx >= ll(1)) && norm(dd-pd)<1e-9
    res = [lx, ll(2)];
    return;
end
lx = (ru(2)-(p(2)-p(1)*k))/k;
pd = ([lx, ru(2)] - p)/norm([lx, ru(2)] - p);
if lx <= ru(1) && lx >= ll(1) && norm(dd-pd)<1e-9
    res = [lx, ru(2)];
    return;
end
