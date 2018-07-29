function [Me]=elm(le,m)

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

Me=m*le/420*[140 0 0 70 0 0;
0 156 22*le 0  54 -13*le  ;
0 22*le 4*le*le 0 13*le -13*le*le;
70 0 0 140 0 0  ;
0 54 13*le 0 156 -22*le ;
0 -13*le -3*le*le 0 -22*le 4*le*le];