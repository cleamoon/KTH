function sys = minphase
%
% sys = minphase
%
% computes a state-space model for the linearized model of the
% quadruple-tank process for a minimum phase case
% 

% Magnus Åkerblad 2000-01-20
% This file was changed by Jonas Wijk 2003-01-07, to work with the new watertanks.

% Operating levels of tanks
h10 = 11;      % i cm (nedre vänstra tanken)
h20 = 7.8;      % i cm (nedre högra tanken)
h30 = 12.9;      % i cm (övre vänstra tanken)
h40 = 8.8;      % i cm (övre högra tanken)

% Operating voltage of pumps
u10 = 7.5;     % i V
u20 = 7.5;     % i V

% Operating actuator proportional constants
k1 = 4.27;     % i cm^3/(Vs)
k2 = 3.95;     % i cm^3/(Vs)

% Outlet areas
a1 = 0.234;   % i cm^2
a2 = 0.233;   % i cm^2
a3 = 0.066;  % i cm^2
a4 = 0.068;  % i cm^2

% Valve settings
gam1 = 0.625;
gam2 = 0.625;

% Compute state-space model for linearized model
sys = linmodel(a1,a2,a3,a4,h10,h20,h30,h40,u10,u20,k1,k2,gam1,gam2);