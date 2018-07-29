function out = feas(s, ds, dsd)
global ne regionobs xyp xye;
if ds < norm(dsd)
    v = ds;
else 
    v = norm(dsd);
end
t = s + v*dire(dsd);
% for j = 1:4
%     [x0, y0, x1, y1] = deal(regionobs(j, 1), regionobs(j, 2), regionobs(j, 3), regionobs(j, 4));
%     if s(1) >= x0 && s(1) <= x1 && s(2) >= y0 && s(2) <= y1
%         disp(s);
%         disp(dsd);
%         disp(v);
%         disp('warning');
%     end
% end
if t(1) > 0 && t(1) <= ne && t(2) > 0 && t(2) <= ne
    out = t;
else
    out = s;
end
% if t(1) > 0 && t(1) <= ne && t(2) > 0 && t(2) <= ne
%     if c < 4
%         xyp(c, :) = t;
%     else
%         xye = (t);
%     end
% else
%     if c < 4
%         xyp(c, :) = xyp(c, :);
%     else
%         xye = xye;
%     end
% end