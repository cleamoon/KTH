function integral = ConvDiffTimeDep(u, v, w, du, dv, dw, dx, ds, x, d, t, eq)

% Variational formulation of time-dependent convection-diffusion.
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

k = 0.05;

if eq == 1
  integral = u*v*dx + k*(0.1*du'*dv*dx + b(x,d,t)'*du*v*dx + g(x,d,t)*u*v*ds);
else
  integral = k*(f(x,d,t)*v*dx + (g(x,d,t)*gd(x,d,t) - gn(x,d,t))*v*ds) + w(1)*v*dx;
end

%--- Convection ---
function y = b(x, d, t)
y = 5*[-(x(2)-0.5); (x(1)-0.5)];

%--- Conductivity (penalty factor) ---
function y = g(x, d, t)
y = 0;  

%--- Dirichlet boundary condition ----
function y = gd(x, d, t)
y = 0;

%--- Neumann boundary condition ---
function y = gn(x, d, t)
y = 0;

%--- Right-hand side, source term ---
function y = f(x, d, t)

if norm(x - [0.75; 0.5]) < 0.1 & abs(t - round(t)) < 0.1
  y = 1;
else
  y = 0;
end
