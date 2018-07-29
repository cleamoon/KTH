function Gr = modelred(G,n)
%
% sys = modelred(Fr,order)
%
% makes a balanced model reduction of the system G such that Gr is of 
% order n, where n has to be less than or equal to the order of G.

% Anders Hansson 1999-01-13

N = length(pole(G));
[Gb,Gram,T,Ti] = balreal(G);
Gr = modred(Gb,[(n+1):N]);
