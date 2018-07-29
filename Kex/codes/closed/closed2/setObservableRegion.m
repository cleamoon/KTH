function setObservableRegion(c)
global ne nn pos r Mobs;
if c == 1
    tr = r;
else
    tr = ne*2;
end
Mobs = zeros(ne, ne);
for k = 1:nn; % for each runner (pursuer)
    txy = pos(k, :);
    Mdone = zeros(ne, ne);
    for a = 1:360
        trxy = loc(txy + tr*[cosd(a), sind(a)]);
        if ~Mdone(trxy(1), trxy(2))
            Bresenham(loc(txy), trxy);
            Mdone(trxy(1), trxy(2)) = true;
        end
    end
end
% for i = 1:ne
%     for j = 1:ne
%         lc = [i, j];
%         for k = 1:nn
%             p = pos(k, :);
%             if norm(lc-p) < r
%                 Mobs(i, j) = 1;
%             end
%         end
%     end
% end