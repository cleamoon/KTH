function run()
global xyp xye ve vp up ue t S tend;
for i = 1:3
    xyp(i,:) = feas(xyp(i, :),vp, up(i, :));
    % feas(xyp(i, :),vp, up(i, :), i);
end
xye = feas(xye, ve, (ue));
% feas(xye, ve, (ue), 4);
tn = t+1;
if tn ~= t
    S(:,tn) = [xyp(1,1), xyp(1,2), xyp(2,1), xyp(2,2), xyp(3,1) xyp(3,2), xye(1), xye(2)];
end
