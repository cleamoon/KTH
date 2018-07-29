function d = path_determ_pur(pd, i)
% Virtual vehicle approach
global D S dt s R omegam;
% pd = [R R];
[x0, y0] = deal(S(1,1), S(2,1));
xd = x0 + R*cos(s(i));
yd = y0 + R*sin(s(i));
% xd = pd(1) - R*cos(s(i));
% yd = pd(2) - R*sin(s(i));
[x, y, phi] = deal(S(1,i), S(2,i), S(4,i));
dx = xd - x;
dy = yd - y;
rho = sqrt(dx*dx+dy*dy);
phid = atan(dy/dx);
thetar = s(i)+pi/2;
pp = -R*sin(s(i));
qp = R*cos(s(i));
alphac = 1;
k = 1;
drho = 0.0005;
dphi = 0.0005;
epsilon = drho;
v0 = 2;
if rho > drho
    tphid = phid;
else
    tphid = (phid*(-2*rho^3+3*epsilon*rho^2)+thetar*(-2*(epsilon-rho)^3+3*epsilon*(epsilon-rho)^2))/epsilon^3;
end
tDeltaphi = tphid - phi;
% sp = exp(alphac*v0/rho)*exp(-alphac*rho)*v0/sqrt(pp*pp+qp*qp);
sp = exp(-alphac*rho)*v0/sqrt(pp*pp+qp*qp);
%sp = v0/sqrt(pp*pp+qp*qp);
s(i) = s(i) + sp*dt;
vd = dx*cos(phi)+dy*sin(phi);
deltafd = k * min(abs(tDeltaphi), omegam(i))*sign(tDeltaphi) + tphid;
% vd = sqrt(dx*dx+dy*dy);
D(:, i) = [vd deltafd];
end