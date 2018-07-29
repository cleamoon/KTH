function [ll, ru, p, x0, y0, x1, y1] = findRegion(q)
global regions obstacles;
for i = 1:4
    [x0, y0, x1, y1] = deal(regions(i, 1), regions(i, 2), regions(i, 3), regions(i, 4));
    if q(1) >= x0 && q(1) <= x1 && q(2) >= y0 && q(2) <= y1
        ll = [obstacles(i, 1), obstacles(i, 2)];
        ru = [obstacles(i, 3), obstacles(i, 4)];
        p = (ll+ru)/2;
        % disp('find it');
        break;
    end
end