function integral = NavierStokesContinuity(u, v, w, du, dv, dw, dx, ds, x, d, t, eq)

% Variational formulation of the continuity equation in the Navier-Stokes system.
% (c) Johan Hoffman and Anders Logg 2003.
% Licensed under the GNU GPL Version 2.

U    = [w(1); w(2)];
dU1  = dw(:,1);
dU2  = dw(:,2);
UdU  = [U'*dU1; U'*dU2];
divU = dU1(1) + dU2(2);

d1 = 2*sqrt(dx/pi);

if eq == 1
  integral = d1*du'*dv*dx + 0.1*u*v*dx;
else
  integral = - d1*UdU'*dv*dx - divU*v*dx + d1*f(x,d,t)'*dv*dx;
end

%--- Right-hand side, source term ---
function y = f(x, d, t)
y = [0;0];
