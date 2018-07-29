format long;

M = 1000;

R = 6370*1000;
g0 = 9.800;
cd = 0.0;
A = (3.66/2)^2*pi;
rho = 1.225;
Isp = 311;
T = 7607*1000;

div = 1;

ent1 = 162/div;
Mp = 395700/div;
Ms = 549054-395700;
mass = Mp + M;


v0 = 1;
gamma = 5;
% (atmosisa(x(3)-R)*[0; 0; 0; 1])
opts=odeset('RelTol', 1e-5, 'AbsTol', 1e-5, 'MaxStep', 1);

tra = @(t, x) [ ...
    T/x(5)-cd*A*crho(x(4))-(g0*R^2/(R+x(4))^2-(x(1)*cosd(x(2)))^2/(R+x(4)))*sind(x(2)); ...
    -1/x(1)*((g0*R^2/(R+x(4))^2)-(x(1)*cosd(x(2)))^2/(R+x(4)))*cosd(x(2)); ...
    x(1)*cosd(x(2)); ...
    x(1)*sind(x(2)); ...
    -T/Isp/g0; ...
    ];

[t, xa] = ode45(tra, [0, ent1], [0.12, gamma, 0, 0, mass], opts);
%plot(xa(:,3), xa(:,4))


cd = 0;
Isp = 348;
T = 934*1000;
ent2 = 397;
mass = 3900+92670+M;
tra = @(t, x) [ ...
    T/x(5)-cd*A*crho(x(4))-(g0*R^2/(R+x(4))^2-(x(1)*cosd(x(2)))^2/(R+x(4)))*sind(x(2)); ...
    -1/x(1)*((g0*R^2/(R+x(4))^2)-(x(1)*cosd(x(2)))^2/(R+x(4)))*cosd(x(2)); ...
    x(1)*cosd(x(2)); ...
    x(1)*sind(x(2)); ...
    -T/Isp/g0; ...
    ];

ang = xa(end,2)-25;

[t,xb] = ode45(tra, [0, ent2], [xa(end,1), ang, xa(end,3), xa(end,4), mass], opts);

xx = [xa; xb];
tot = ent1+ent2;
n = (size(xx)*[1;0])-1;
%plot(0:tot/n:tot, (xx-R)/1000);
plot(xx(:,3),xx(:,4))
