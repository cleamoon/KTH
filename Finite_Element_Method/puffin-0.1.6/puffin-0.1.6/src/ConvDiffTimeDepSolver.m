% A simple solver for time-dependent convection-diffusion.
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

% Load the mesh
square

T = 3.5;
k = 0.05;
time = 0;

% Initial condition
U0 = zeros(size(p,2),1);
U1 = zeros(size(p,2),1);

% Assemble matrix
A = AssembleMatrix(p, e, t, 'ConvDiffTimeDep', [], 0);

clear M

% Time-stepping
for n = 1:70
     
  time = time + k;
  U0 = U1;

  % Assemble vector
  b = AssembleVector(p, e, t, 'ConvDiffTimeDep', U0, time);

  % Solve the linear system
  U1 = A \ b;
   
  % Plot solution
  pdesurf(p, t, U1)
  shading interp
  view(2)
  M(n) = getframe;
  drawnow
  disp(['t = ' num2str(time) ' Press any key to continue.'])
  pause

end

movie(M)
