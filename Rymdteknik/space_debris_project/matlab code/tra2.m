format long;

M = 1000;
R = 6370*1000;
g0 = 9.800;
cd = 0.47;
A = (3.66/2)^2*pi;
rho = 1.225;
Isp = 311;
T = 7607*1000; %% not real thrust change it

div = 1; % percentage of propellant
ent1 = 162/div; % burn time
Mp = 395700/div; % propellant

Ms = 549054-395700; % system mass
mass = Mp + M + Ms; % total mass

gamma0 = 5; % initial angle 

% (atmosisa(x(3)-R)*[0; 0; 0; 1])
opts=odeset('RelTol', 1e-5, 'AbsTol', 1e-5, 'MaxStep', 0.1);

tra = @(t, x) [ ...
    T/x(5)-cd*A*crho(x(4))-(g0-(x(1)*cosd(x(2)))^2/(R+x(4)))*sind(x(2)); ...
    -1/x(1)*(g0-(x(1)*cosd(x(2)))^2/(R+x(4)))*cosd(x(2)); ...
    x(1)*cosd(x(2)); ...
    x(1)*sind(x(2)); ...
    -T/Isp/g0; ...
    ];

[t, xa] = ode45(tra, [0, ent1], [0.2, gamma0, 0, 0, mass], opts);

plot(xa(:,3),xa(:,4))
