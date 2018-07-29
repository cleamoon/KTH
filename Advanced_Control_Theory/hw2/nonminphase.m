function sys = nonminphase
%
% sys = nonminphase
%
% computes a state-space model for the linearized model of the
% quadruple-tank process for a non-minimum phase case
% 

% Magnus Åkerblad 2000-01-20
% This file was changed by Jonas Wijk 2003-01-07, to work with the new watertanks.

% Operating levels of tanks
h10 = 22;      % i cm (nedre vänstra tanken)
h20 = 22;      % i cm (nedre högra tanken)
h30 = 7;       % i cm (övre vänstra tanken)
h40 = 7;       % i cm (övre högra tanken)

% Operating voltage of pumps
u10 = 7.5;     % i V
u20 = 7.5;     % i V

% Operating actuator proportional constants
k1 = 4.32;     % i cm^3/(Vs)
k2 = 3.74;     % i cm^3/(Vs)

% Outlet areas
a1 = 0.1678;   % i cm^2
a2 = 0.1542;   % i cm^2
a3 = 0.1591;  % i cm^2
a4 = 0.1685;  % i cm^2

% Valve settings
gam1 = 1-0.625;
gam2 = 1-0.625;

% Compute state-space model for linearized model
sys = linmodel(a1,a2,a3,a4,h10,h20,h30,h40,u10,u20,k1,k2,gam1,gam2);