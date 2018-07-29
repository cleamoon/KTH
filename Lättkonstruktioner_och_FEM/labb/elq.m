function [Qe]=elq(le,q,qt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assemble element load vector
% File name: elq.m
% 
% le [m]	Element length
% q  [N/m]	Element pressure load (constant in this version)
% Qe is returned - element load vector
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = le;
p = q;
Qe = [p * h / 0.2e1 -p * h ^ 2 / 0.12e2 p * h / 0.2e1 p * h / 0.2e1 p * h ^ 2 / 0.12e2 p * h / 0.2e1;];
