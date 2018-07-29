function velocityCalculator(c, i) 
global up xyp vp regionobs;
kprop = 1;
% for i = 1:3
    txy1 = small2big(xyp(i, :));
    txy2 = small2big(c);
    d = txy2 - txy1;
    dn = txy1 + ((vp)/3*d/norm(d));
    dn = big2small(dn);
%     for j = 1:4
%         [x0, y0, x1, y1] = deal(regionobs(j, 1), regionobs(j, 2), regionobs(j, 3), regionobs(j, 4));
%         if dn(1) >= x0 && dn(1) <= x1 && dn(2) >= y0 && dn(2) <= y1
%             disp(dn);
%             disp(txy1);
%             disp((vp)*d/norm(d));
%             disp('warning');
%         end
%     end
%     up(i)
%     reverseTrans(dn)
%     xyp(i, :)
    up(i, :) = kprop*((dn) - xyp(i, :));
    % up(i, :) = c-xyp(i, :);
    %up(i, :) = xyp(i, :) - xye;
% end
