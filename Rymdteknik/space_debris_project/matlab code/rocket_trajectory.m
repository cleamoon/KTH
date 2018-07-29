clear all
close all

format LONG

% This script plots the trajectory of a rocket, giving all its parameters.
% It is base on the Falcon 9 rocket

% [solb solvv]=solve ([-3008.9*log((23100+3900+n+1000)/(23100+3900+b+n+1000))==4500, -3377*log((3900+1000)/(3900+n+1000))==4500], [b n])

%% Defining parameters

% Satellite parameters

M=1000; % mass of the satellite in kg (payload)

% Earth parameters

R_earth=6371e3; % radius of earth in m
g0=9.80665; 
rho_ssl=1.225; %in kg/m^3
mu=6.67408e-11*6e24;

% Rocket parameters

cd=0.47; % drag coefficient for a sphere
A=pi*(3.66/2)^2; % cross sectional area

div1=1; % proportion of propellant we put in stage 1(initial input)
isp1=311; % specific impulse of stage 1
tb1=180*div1; % burn time of stage 1
max_propellant_mass_1=395700; % maximum propellant for stage 1

div2=1;
isp2=340;
tb2=372*div2;
max_propellant_mass_2=92670;

system_mass=23100+3900;
total_mass=max_propellant_mass_1*div1+max_propellant_mass_2*div2+system_mass+M;



%% Solver for lanch premises

% Initial conditions

global gamma0
gamma0=89*pi/180;
Y0X=[0 gamma0 0 0 total_mass];
Y0X_own=[0 gamma0 0 0 total_mass];

% Time span

global tbx
tbx=26.5;
tspanx=[0 tbx];
tspanx_own=[0 tbx];

% Solve

opts=odeset('RelTol', 1e-5, 'AbsTol', 1e-5, 'MaxStep', 1);

[tx yx]=ode45(@solve_trax, tspanx, Y0X, opts);
[tx_own yx_own]=ode45(@solve_trax_own, tspanx_own, Y0X_own, opts);

%% Solver for stage 1

% Initial conditions

Lx=length(tx);
Y01=[yx(Lx,1) yx(Lx,2) yx(Lx,3) yx(Lx,4) yx(Lx,5)];

Lx_own=length(tx_own);
Y01_own=[yx_own(Lx_own,1) yx_own(Lx_own,2) yx_own(Lx_own,3) yx_own(Lx_own,4) yx_own(Lx_own,5)];

% Time span

tspan1=[tbx tb1];
tspan1_own=[tbx tb1];


% Solve

[t1,y1]=ode45(@solve_tra1, tspan1, Y01, opts);
[t1_own,y1_own]=ode45(@solve_tra1_own, tspan1_own, Y01_own, opts);


%% Solver for stage 2

% Initial conditions

L=length(t1);

Y02=[y1(L,1) y1(L,2) y1(L,3) y1(L,4) y1(L,5)-23100];

global gamma1
gamma1=y1(L,2);

L_own=length(t1_own);

Y02_own=[y1_own(L_own,1) y1_own(L_own,2) y1_own(L_own,3) y1_own(L_own,4) y1_own(L_own,5)-23100];

% Time span

tspan2=[tb1 tb1+tb2];
tspan2_own=[tb1 tb1+tb2];


% Solve

[t2 y2]=ode45(@solve_tra2, tspan2, Y02, opts);
[t2_own y2_own]=ode45(@solve_tra2_own, tspan2_own, Y02_own, opts);

%% Final result

t=[tx;t1;t2];
y=[yx;y1;y2];

t_own=[tx_own;t1_own;t2_own];
y_own=[yx_own;y1_own;y2_own];

figure 
plot(y(:,3),y(:,4)/1000)
xlabel 'X (m)'
ylabel 'H (km)'
title 'Rocket trajectory'

% figure 
% plot(t, y(:,4))

figure 
plot(t, y(:,2)*180/pi)
% 
% figure
% plot(t, y(:,5))
