function integral = HeatEquation(u, v, w, du, dv, dw, dx, ds, x, d, t, eq)

% Variational formulation of the heat equation.
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

k = pi/(2*10);

if eq == 1
  integral = u*v*dx + k*(du'*dv*dx + g(x,d,t)*u*v*ds);
else
  integral = k*(f(x,d,t)*v*dx + (g(x,d,t)*gd(x,d,t) - gn(x,d,t))*v*ds) + w*v*dx;
end

%--- Conductivity (penalty factor) ---
function y = g(x, d, t)
y = 1e7;

%--- Dirichlet boundary condition ----
function y = gd(x, d, t)
y = 0;

%--- Neumann boundary condition ---
function y = gn(x, d, t)
y = 0;

%--- Right-hand side, source term ---
function y = f(x, d, t)
y = x(1)*(1-x(1))*x(2)*(1-x(2))*cos(t) + 2*(x(1)*(1-x(1))+x(2)*(1-x(2)))*sin(t);
