function res = small2big(q) 
[ll, ru, p, x0, y0, x1, y1] = findRegion(q);
d = q - p;
a = norm(distance2rectangle(q, p, ll, ru)-p);
b = norm(distance2rectangle(q, p, [x0, y0], [x1, y1])-p)-a;
% b = norm(d)-a;
% if norm(d) > a
    res = (norm(d)-a)*d/norm(d)*(a+b)/b + p;
% else
%     % res = small2big(q-[1, 1]);
%     if norm(d) > 1e-5
%         res = small2big(a*d/norm(d)+q);
%     else
%         res = q;
%     end
% end