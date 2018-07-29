function [Kesigma]=elksigma(le,P,I0,A)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assemble element initial stress stiffness matrix
% File name: elksigma.m
% 
% le [m]	Element length
% P  [N]	"Tensile" buckling load
% Kesigma is returned - element initial stress matrix
%
% Make sure the initial stress matrix is symmetric!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=le;
Nx = P;
Ah = A*h;
I0sNx = I0*Nx;
Kesigma = [0.6e1 / 0.5e1 * Nx / h -Nx / 0.10e2 Nx / h -0.6e1 / 0.5e1 * Nx / h -Nx / 0.10e2 -Nx / h; -Nx / 0.10e2 0.2e1 / 0.15e2 * Nx * h 0 Nx / 0.10e2 -Nx * h / 0.30e2 0; Nx / h 0 Nx / h + I0sNx / Ah -Nx / h 0 -Nx / h - I0sNx / Ah; -0.6e1 / 0.5e1 * Nx / h Nx / 0.10e2 -Nx / h 0.6e1 / 0.5e1 * Nx / h Nx / 0.10e2 Nx / h; -Nx / 0.10e2 -Nx * h / 0.30e2 0 Nx / 0.10e2 0.2e1 / 0.15e2 * Nx * h 0; -Nx / h 0 -Nx / h - I0sNx / Ah Nx / h 0 Nx / h + I0sNx / Ah;];
