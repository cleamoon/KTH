function chase()
global xyp xye vp up regionobs;
% for i = 1:3
%     txy1 = small2big(xyp(i, :));
%     txy2 = small2big(xye);
%     d = txy2 - txy1;
%     dn = txy1 + ((vp)*d/norm(d));
% %     up(i)
% %     reverseTrans(dn)
% %     xyp(i, :)
%     up(i, :) = big2small(dn) - xyp(i, :);
%     %up(i, :) = xyp(i, :) - xye;
% end
for i = 1:3
    velocityCalculator(xye, i);
end
