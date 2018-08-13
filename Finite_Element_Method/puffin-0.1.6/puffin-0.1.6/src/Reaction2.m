function integral = Reaction2(u, v, w, du, dv, dw, dx, ds, x, d, t, eq)

% Variational formulation of the second equation of the
% convection-diffusion-reaction system.
%
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

k = 0.05;
c = 3.0;

if eq == 1
  integral = u*v*dx + k*(0.01*du'*dv*dx + b(x,d,t)'*du*v*dx);
else
  integral = k*(-c*w(2)*w(3) + f(x,d,t))*v*dx + w(1)*v*dx;
end

%--- Convection ---
function y = b(x, d, t)
y = 5*[-(x(2)-0.5); (x(1)-0.5)];

%--- Source term ---
function y = f(x, d, t)

if norm(x - [0.75; 0.5]) < 0.1 & abs(t - round(t)) < 0.1
  y = 20;
else
  y = 0;
end
