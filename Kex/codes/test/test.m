%% chase unit circle clockwise
nstep = 3000;
dt = 0.01;
lx = ones(nstep, 1);
ly = ones(nstep, 1);
lvx = ones(nstep, 1);
lvy = ones(nstep, 1);
gamma = 1;
k = 1;
drho = 0.0005;
dphi = 0.0005;
maxv = 5;
maxomega = 2;
x = 10;
y = 10;
s = pi;
phi = pi/2;
ax = 3;
ay = 3;
as = 3;
r = 3;
omega = 8;
v0 = omega*r;
alphaphi = 30;
sd = pi*8/11;
vx = 0;
vy = 5;
deltaf = 0;
for i=1:1:nstep 
    r = 5;
    % sd = i/nstep;
    % s = s + 2*pi/nstep;
    % s = 2*pi*i/nstep;
    xd = r*cos(s);
    yd = r*sin(s);
    pp = -r*sin(s);
    qp = r*cos(s);
    rho = sqrt((xd-x)*(xd-x)+(yd-y)*(yd-y));
    alpha = 1;
    c = 1;
    Deltax = xd-x;
    Deltay = yd-y;
    phid = atan(Deltay/Deltax);
    thetar = sd+pi/2;
    epsilon = drho;
    if rho > drho
        tphid = phid;
    else
        tphid = (phid*(-2*rho^3+3*epsilon*rho^2)+thetar*(-2*(epsilon-rho)^3+3*epsilon*(epsilon-rho)^2))/epsilon^3;
    end
    tDeltaphi = tphid - phi;
    % k = 0.001;
    d = 3;
    sp = exp(alpha*v0/rho)*exp(-alpha*rho)*v0/sqrt(pp*pp+qp*qp);
    deltafd = k * min(abs(tDeltaphi), maxomega)*(tDeltaphi/abs(tDeltaphi)) + tphid;
    deltaf = deltaf + (deltafd-deltaf)/abs(deltafd-deltaf)*alphaphi*dt;
    vxd = min(gamma * abs(Deltax), maxv)*(Deltax/abs(Deltax));
    vyd = min(gamma * abs(Deltay), maxv)*(Deltay/abs(Deltay));
    vx = vx + (vxd-vx)/abs(vxd-vx)*ax*dt;
    vy = vy + (vyd-vy)/abs(vyd-vy)*ay*dt;
    lx(i) = x;
    ly(i) = y;
    lvx(i) = vx;
    lvy(i) = vy;
    phi = phi + deltaf*dt;
    x = x + vx*dt+(vxd-vx)/abs(vxd-vx)*ax*dt*dt/2;
    y = y + vy*dt+(vyd-vy)/abs(vyd-vy)*ay*dt*dt/2;
    s = s + sp*dt
end
figure;
hold on;
axis equal;
quiver(lx, ly, lvx, lvy, 'bo');
plot(r*cos((1:1:nstep)*dt), r*sin((1:1:nstep)*dt), 'r')
grid on;