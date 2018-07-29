function [F,gam] = rloop(L,alpha)
%
% [F,gam] = rloop(L,alpha)
%
% Computes the robust controller proposed by Glover & McFarlane (1989)
% as described in Glad, T. and Ljung, L.: Reglerteori - Flervariabla och
% olinjara metoder, Studentlitteratur, 1997
%

% Anders Hansson 1998-12-14

[A,B,C,D] = ssdata(L);
[P1,P2,LAMP,PERR,WELLPOSED,Z] = aresolv(A',B*B',C'*C,'schur');
[P1,P2,LAMP,PERR,WELLPOSED,X] = aresolv(A,C'*C,B*B','schur');
lambdam = max(eig(X*Z));
gam = alpha*sqrt(1+lambdam);
R = eye(size(Z))-(eye(size(Z))+Z*X)/(gam^2);
L = B'*X;
K = R\(Z*C');
Ac = A-B*L-K*C;
Bc = K;
Cc = L;
F = ss(Ac,Bc,Cc,zeros(size(D)));
