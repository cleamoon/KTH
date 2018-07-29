function pd = desired_pur(i, ct)
global nm nh S R vm omegam calculated_time perm_opti theta_opti decided s;
[x0, y0] = deal(S(1,1), S(2,1));
% if calculated_time ~= ct
if ~decided
    p = perms(1:nh);
    [nperm, ~] = size(p);
    mint = Inf;
    % state of the mouse
    for j = 1:nperm
        h = p(j,:);
        for theta = 0:2*pi/360:2*pi
            maxtj = -1;
            ds = ones(nh,1);
            dphi = ones(nh,1);
            for k = 1:nh
                thetak = theta + 2*pi/nh*(h(k)-1);
                xm = x0 + R*cos(thetak);
                ym = y0 + R*cos(thetak);
                phim = mod(thetak+pi/2, 2*pi);
                [xi, yi, phii] = deal(S(1,k), S(2,k), S(4,k));
                ds(k) = sqrt((xi-xm)^2+(yi-ym)^2);
                dphi(k) = abs(mod(phii-phim, 2*pi));
                maxtj = max(maxtj, max(ds(k)/vm(k), dphi(k)/omegam(k)));
            end
            if maxtj < mint
                mint = maxtj;
                theta_opti = theta;
                perm_opti = h;
            end
        end
    end
    calculated_time = ct;
    decided = true;
end
k = find(perm_opti==(i-nm));
thetak = theta_opti + 2*pi/nh*(perm_opti(k)-1);
s(i) = thetak;
xm = x0 + R*cos(thetak);
ym = y0 + R*cos(thetak);
pd = [thetak];
end