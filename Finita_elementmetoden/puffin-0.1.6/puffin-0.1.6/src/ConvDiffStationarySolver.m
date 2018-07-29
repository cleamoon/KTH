% A simple solver for the stationary convection-diffusion equation.
% Copyright (C) 2003 Johan Hoffman and Anders Logg.
% Licensed under the GNU GPL Version 2.

% Load the mesh
cylinder

% Assemble matrix
A = AssembleMatrix(p, e, t, 'ConvDiffStationary', [], 0);

% Assemble vector
b = AssembleVector(p, e, t, 'ConvDiffStationary', [], 0);

% Solve the linear system
U = A \ b;

% Plot solution
figure(1); clf
pdesurf(p,t,U)
shading faceted
title('Computed solution')
