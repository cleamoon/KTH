% A simple solver for Navier-Stokes equations (cG(1)dG(0)). 
% (c) Johan Hoffman and Anders Logg 2003.
% Licensed under the GNU GPL Version 2.

% Load the mesh
square
%square_refined
%cylinder
%cylinder_refined

T    = 10;
k    = 0.1;
time = 0;
N    = floor(T/k);
tol  = 0.01;

% Initial values
Uxp = zeros(size(p,2),1);
Uyp = zeros(size(p,2),1);

Ux = zeros(size(p,2),1);
Uy = zeros(size(p,2),1);
P  = zeros(size(p,2),1);

Ux0 = zeros(size(p,2),1);
Uy0 = zeros(size(p,2),1);
P0  = zeros(size(p,2),1);

% Time-stepping
for n = 1:N

  time = time + k;
  Uxp = Ux;
  Uyp = Uy;

  disp('------------------------------------------------------------')
  disp(['t = ' num2str(time)])
  disp(' ')
  
  % Nonlinear loop 
  for i = 1:50 

    Ux0 = Ux;
    Uy0 = Uy;
    P0  = P;

    %--- First velocity ---

    disp('Solving for x-velocity')
    
    % Assemble linear system
    A = AssembleMatrix(p, e, t, 'NavierStokesMomentum1',  [Ux, Uy, P, Uxp], time);
    b = AssembleVector(p, e, t, 'NavierStokesMomentum1',  [Ux, Uy, P, Uxp], time);

    % Solve the linear system
    Ux = A \ b;

    %--- Second velocity ---
    
    disp('Solving for y-velocity')
    
    % Assemble linear system
    A = AssembleMatrix(p, e, t, 'NavierStokesMomentum2',  [Ux, Uy, P, Uyp], time);
    b = AssembleVector(p, e, t, 'NavierStokesMomentum2',  [Ux, Uy, P, Uyp], time);

    % Solve the linear system
    Uy = A \ b;
   
    %--- Pressure ---
    
    disp('Solving for pressure')
    
    % Assemble linear system
    A = AssembleMatrix(p, e, t, 'NavierStokesContinuity', [Ux, Uy], time);
    b = AssembleVector(p, e, t, 'NavierStokesContinuity', [Ux, Uy], time);

    % Solve the linear system
    P = A \ b;

    %--- Evaluate residual ---
    
    res = norm([Ux,Uy,P]-[Ux0,Uy0,P0]);
    disp(' ')
    disp(['Iteration ' num2str(i) ': residual = ' num2str(res) ' (tol = ' num2str(tol) ')'])
    disp(' ')
    
    if (res < tol)
      break;
    end
  
  end
  
  % Plot solution
  clf
  quiver(p(1,:), p(2,:), Ux, Uy)
  axis equal;
  view(2)
  drawnow

end
