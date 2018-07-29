function [Ke]=elk(le,EI,GJ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assemble element stiffness matrix
% File name: elk.m
% 
% le [m]	Element length
% EI [Nm2]	Element bending stiffness (constant in this version)
% GJ [Nm2]	Element torsional stiffness (constant in this version)
%
% Ke is returned - element stiffness matrix
%
% Make sure the stiffness matrix is symmetric!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=le;
Ke = [12 * EI / h ^ 3 -6 * EI / h ^ 2 0 -12 * EI / h ^ 3 -6 * EI / h ^ 2 0; -6 * EI / h ^ 2 4 * EI / h 0 6 * EI / h ^ 2 2 * EI / h 0; 0 0 GJ / h 0 0 -GJ / h; -12 * EI / h ^ 3 6 * EI / h ^ 2 0 12 * EI / h ^ 3 6 * EI / h ^ 2 0; -6 * EI / h ^ 2 2 * EI / h 0 6 * EI / h ^ 2 4 * EI / h 0; 0 0 -GJ / h 0 0 GJ / h;];


