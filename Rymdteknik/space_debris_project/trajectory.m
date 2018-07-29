format long;

M = 1000;

R = 6370*1000;
g0 = 9.800;
cd = 0.0;
A = (3.66/2)^2*pi;
rho = 1.225;
Isp = 311;
T = 7607*1000;
ent1 = 162;

Mp = 395700;
Ms = 549054-395700;
mass = Mp + M;


v0 = 0.1125;
gamma = 5;
% (atmosisa(x(3)-R)*[0; 0; 0; 1])
opts=odeset('RelTol', 1e-5, 'AbsTol', 1e-5, 'MaxStep', 0.1);

tra = @(t, x) [ ...
    -g0*R^2/x(3)^2*sind(x(2)) - cd*A*crho(x(3))*x(1)^2/2/x(5) + T/x(5); ...
    -g0*R^2/x(3)^2*cosd(x(2))/x(1) + x(1)*cosd(x(2))/x(3) + T/x(5)/x(1); ...
    x(1)*sind(x(2)); ...
    x(1)*cosd(x(2))/x(3); ...
    -T/Isp/g0; ...
    ];
[t, xa] = ode45(tra, [0, ent1], [v0, gamma, R, 0, mass], opts);
%hold on
%plot(xa(:,3).*cosd(xa(:,4)),xa(:,3).*sind(x(:,4)))
%figure
hold on
%plot(xa(:,3).*sind(xa(:,4)),xa(:,3).*cosd(x(:,4))-R)



cd = 0;
Isp = 348;
T = 934*1000;
ent2 = 397;
mass = 3900+92670+M;
tra = @(t, x) [ ...
    -g0*R^2/x(3)^2*sind(x(2)) - cd*A*rho*x(1)^2/2/x(5) + T/x(5); ...
    -g0*R^2/x(3)^2*cosd(x(2))/x(1) + x(1)*cosd(x(2))/x(3) + T/x(5)/x(1); ...
    x(1)*sind(x(2)); ...
    x(1)*cosd(x(2))/x(3); ...
    -T/Isp/g0; ...
    ];

ang = xa(end,2);

[t,xb] = ode45(tra, [0, ent2], [xa(end,1), ang, xa(end,3), xa(end,3), mass], opts);

xx = [xa; xb];
tot = ent1+ent2;
n = (size(xx)*[1;0])-1;
%plot(0:tot/n:tot, (xx-R)/1000);
plot(xx(:,3).*cosd(xx(:,4)),xx(:,3).*sind(xx(:,4))-R)
