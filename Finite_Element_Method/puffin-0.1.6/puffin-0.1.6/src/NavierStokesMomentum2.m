function integral = NavierStokesMomentum2(u, v, w, du, dv, dw, dx, ds, x, d, t, eq)

% Variational formulation of the second momentum equation in the Navier-Stokes system.
% (c) Johan Hoffman and Anders Logg 2003.
% Licensed under the GNU GPL Version 2.

k = 0.1;
a = 0.01;

U  = [w(1); w(2)];
Py = dw(2,3);
up = w(4);

% Modified test function, including stabilization
d1 = 2*sqrt(dx/pi);
vv = v + d1*(U'*dv);

% Variational formulation
if eq == 1
  bc = g(x,d,t)*u*v*ds;
  integral = u*v*dx + k*(a*du'*dv*dx + (U'*du)*vv*dx + bc);
else
  bc = (g(x,d,t)*gd(x,d,t) - gn(x,d,t))*v*ds;
  integral = up*v*dx + k*((f2(x,d,t) - Py)*vv*dx + bc);
end

%--- Conductivity (penalty factor) ---
function y = g(x, d, t)

% Flow around cylinder
%if d == 1
%  y = 0;
%else
%  y = 1e7;
%end  

% Flow in square
%if abs(x(1)-1) < 1e-e6
%if x(1) == 1
%  y = 0;
%else
%  y = 1e7;
%end  

% Driven cavity
y = 1e7;  

%--- Dirichlet boundary condition ----
function y = gd(x, d, t)
y = 0;

%--- Neumann boundary condition ---
function y = gn(x, d, t)
y = 0;

%--- Right-hand side, source term ---
function y = f2(x, d, t)
y = 0;
