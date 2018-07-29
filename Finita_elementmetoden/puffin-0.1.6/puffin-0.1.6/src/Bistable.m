function integral = Bistable(u, v, w, du, dv, dw, dx, ds, x, d, t, eq)

% Variational formulation of the bistable equation.
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

k = 0.1;

if eq == 1
  integral = u*v*dx + k*0.01*du'*dv*dx;
else
  integral = k*w(2)*(1 - w(2)^2)*v*dx + w(1)*v*dx;
end
