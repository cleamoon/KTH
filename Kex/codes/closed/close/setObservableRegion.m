function setObservableRegion(c)
% calculate the observable map by the pursuers with the sight length r
global ne n xyp r;
% initialization the map, '0' means unobservable and '1' means observable
if c == 1
    tr = r;
else
    tr = ne*2;
end
for k = 1:n; % for each runner (pursuer)
    txy = xyp(k, :);
    Mdone = zeros(ne, ne);
    for a = 1:360
        trxy = loc(txy + tr*[cosd(a), sind(a)]);
        if ~Mdone(trxy(1), trxy(2))
            Bresenham(loc(txy), trxy, c);
            Mdone(trxy(1), trxy(2)) = true;
        end
    end
end