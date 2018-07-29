function integral = Reaction1(u, v, w, du, dv, dw, dx, ds, x, d, t, eq)

% Variational formulation of the first equation of the
% convection-diffusion-reaction system.
%
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

k = 0.05;
c = 3.0;

if eq == 1
  integral = u*v*dx + k*(0.01*du'*dv*dx + b(x,d,t)'*du*v*dx);
else
  integral = - k*c*w(2)*w(3)*v*dx + w(1)*v*dx;
end

%--- Convection ---
function y = b(x, d, t)
y = 5*[-(x(2)-0.5); (x(1)-0.5)];
