% A simple solver for the bistable equation.
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

% Load the mesh
square

T = 20;
k = 0.1;
time = 0;

% Initial condition
U0 = zeros(size(p,2),1);
for i = 1:size(p,2)
  x = p(:,i);
  U0(i) = cos(2*pi*x(1)^2)*cos(2*pi*x(2)^2);
end
U1 = U0;

% Assemble matrix
A = AssembleMatrix(p, e, t, 'Bistable', [], 0);

clear M

% Time-stepping
for n = 1:200
     
  time = time + k;
  U0 = U1;

  % Fixed-point iteration
  while 1

    % Assemble vector
    b = AssembleVector(p, e, t, 'Bistable', [U0 U1], time);
    
    % Solve the linear system
    newU1 = A \ b;
    
    % Check if the solution has converged
    if norm(newU1 - U1) < 0.01
      break;
    end
    
    % Update U1 to new value
    U1 = newU1;

  end
   
  % Plot solution
  pdesurf(p, t, U1)
  shading interp
  colormap hot
  view(2)
  M(n) = getframe;
  drawnow
  disp(['t = ' num2str(time) ' Press any key to continue.'])
  pause

end

movie(M);
