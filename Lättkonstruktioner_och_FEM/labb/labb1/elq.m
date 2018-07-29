function [Qe]=elq(le,q,qt)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assemble element load vector
% File name: elq.m
% 
% le [m]	Element length
% q  [N/m]	Element pressure load (constant in this version)
% Qe is returned - element load vector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Qe=(q*le/12)*[6; -le; 0; 6; le; 0];
Qe=Qe+qt*le/2*[0; 0; 1; 0; 0; 1];