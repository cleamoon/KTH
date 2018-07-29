function setObservableRegion(r)
% calculate the observable map by the pursuers with the sight length r
global ne n pp exy;
% initialization the map, '0' means unobservable and '1' means observable
for k = 1:n; % for each runner (pursuer)
    x1 = pp(k, 1);
    y1 = pp(k, 2);
    Mdone = zeros(ne, ne);
    for a = 1:360
        xr = min(max(x1 + r*cosd(a), 1), ne);
        yr = min(max(y1 + r*sind(a), 1), ne);
        x2 = min(max(floor(xr)+1, 1), ne);
        y2 = min(max(floor(yr)+1, 1), ne);
        x = min(max(floor(x1)+1, 1), ne);
        y = min(max(floor(y1)+1, 1), ne);
    %    if (xr>0) && (xr<=ne) && (yr>0) && (yr<=ne) && (x2>0) && (x2<=ne) && (y2>0) && (y2<=ne)
        if Mdone(y2, x2) ~= 1                         
            if r < ne
                Bresenham(x, y, x2, y2, 1);
            else
                Bresenham(x, y, x2, y2, 2);
            end
            Mdone(y2, x2) = 1;
        end
        %end
    end
end