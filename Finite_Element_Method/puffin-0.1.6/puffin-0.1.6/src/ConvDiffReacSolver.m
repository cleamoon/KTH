% A simple solver for a system of convection-diffusion-reaction
% equations modeling the reaction A + B -> C.
%
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

% Load the mesh
circle

T = 5;
k = 0.05;
time = 0;

% Initial conditions for the two concentrations
U10 = ones(size(p,2),1);
U11 = U10;
U20 = zeros(size(p,2),1);
U21 = U20;

% Assemble matrices
A1 = AssembleMatrix(p, e, t, 'Reaction1', [], 0);
A2 = AssembleMatrix(p, e, t, 'Reaction2', [], 0);

clear M

% Time-stepping
for n = 1:100
     
  time = time + k;
  U10 = U11;
  U20 = U21;

  % Fixed-point iteration
  while 1

    % Assemble vectors
    b1 = AssembleVector(p, e, t, 'Reaction1', [U10 U11 U21], time);
    b2 = AssembleVector(p, e, t, 'Reaction2', [U20 U11 U21], time);
    
    % Solve the linear systems
    newU1 = A1 \ b1;
    newU2 = A2 \ b2;
    
    % Check if the solution has converged
    if (norm(newU1 - U11) + norm(newU2 - U21))  < 0.01
      break;
    end
    
    % Update to the new values
    U11 = newU1;
    U21 = newU2;

  end
   
  % Plot solution for first component (2d)
  subplot(2,2,1)
  pdesurf(p, t, U11)
  shading interp
  view(2)

  % Plot solution for first component (3d)
  subplot(2,2,3)
  pdesurf(p, t, U11)
  shading faceted
  view(3)
  axis([-0.3 1.3 -0.3 1.3 0 1.1])

  % Plot solution for second component (2d)
  subplot(2,2,2)
  pdesurf(p, t, U21)
  shading interp
  view(2)

  % Plot solution for second component (3d)
  subplot(2,2,4)
  pdesurf(p, t, U21)
  shading faceted
  view(3)
  axis([-0.3 1.3 -0.3 1.3 0 1.1])

  % Create animation
  M(n) = getframe;
  disp(['t = ' num2str(time) ' Press any key to continue.'])
  pause

end

movie(M);
