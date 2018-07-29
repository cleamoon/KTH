%% Assignment 2
% Individual data 
alpha_i = 0;
D = 2.5;
d = 0.4;
cr = 12/100;
ct = 9/100;
a0 = 0.11;
cl_max = 1.5;
dcl = 0.3;
dalpha = 1;
BL = 3;
cd0 = 0.0092;
k = 0.0141;

% pre calculation
format long;
pre = 0.001;
plt = 0;
calc = 0;

chord = @(x) cr-(cr-ct)*(x-r)/(R-r);
beta1 = @(x) alpha_ideal + atand((J_base-0.1)/pi/(x/R));
beta2 = @(x) alpha_ideal + atand((J_base)/pi/(x/R));
beta3 = @(x) alpha_ideal + atand((J_base+0.1)/pi/(x/R));

cl = @(x) ((a0*x-a0*dalpha*((a0*x)/(cl_max+a0*dalpha))^(1+cl_max/a0/x))*(x<alpha_cr) ...
    +(cl_max - dcl + (a0*x - cl_max)/5)*(x>alpha_cr))*(x>0)+ ...
    ((a0*(-x)-a0*dalpha*((a0*(-x))/(cl_max+a0*dalpha))^(1+cl_max/a0/(-x)))*((-x)<alpha_cr) ...
    +(cl_max - dcl + (a0*(-x) - cl_max)/5)*((-x)>alpha_cr))*(x<0)*(-1);

cd = @(alpha) ((cd0 + k*(a0*alpha)^2)*(alpha < cl_max/a0)+(cd0 + k*cl_max^2 + 2.5*k*cl_max*(a0*alpha-cl_max))*(alpha > cl_max/a0))*(x > 0) ...
    + ((cd0 + k*(a0*(-alpha))^2)*((-alpha) < cl_max/a0)+(cd0 + k*cl_max^2 + 2.5*k*cl_max*(a0*(-alpha)-cl_max))*((-alpha) > cl_max/a0))*(x < 0);

phi = @(x) atand(J_base/pi/(x/R));
