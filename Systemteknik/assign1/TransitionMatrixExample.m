clear, clc 
echo on
 
format compact, format short
% Random positive matrix with row sums equal to one.
P=rand(5);
P=diag(1../sum(P'))*P

pause

%% Determine different powers of P
P^1
P^2
P^3
P^4
format long
P^15
format short
% the values become almost constant along columns

pause
%%   Eigenvectors V and eigenvalues on the diagonal of E
[V,E]=eig(P)

pause
% MATH EXPLANATION FOR CONVERGENCE OF POWERS OF P
% The eigenvalues of P have absolute value less than 1
% we know that at least one of them is 1
% If there is only one eigenvalue with absolute value one, 
% then there exists a limit of P^n as n -> oo and
% it can be determined from the eigendecomposition of P
%
% We know P   = V * E   * inv(V)
%         P^n = V * E^n * inv(V)
%         E^n -> diag(eye(1,5))
real(V*diag(eye(1,5))*inv(V))


pause

%% Not irreducible case
% Sometimes the matrix P does not converge to some 
% matrix with constant values along the columns

% What can go wrong ?
P1=rand(3);
P1=diag(1../sum(P1'))*P1
P2=rand(2);
P2=diag(1../sum(P2'))*P2
PP=blkdiag(P1,P2)

PP^2
PP^3
PP^4
PP^15

[VV,EE]=eig(PP)
% Note that two eigenvalues have absolute value one.
%
% The Markov theory explanation is that the chain 
% consists of two subchains 123 and 45 that do not 
% communicate with each other

pause


%% Periodic case
PPP=[0 1 0; 0 0 1;1 0 0]
PPP^2
PPP^3
PPP^4
PPP^15


[VVV,EEE]=eig(PPP)
% Note that three eigenvalues have absolute value one
%
% The Markov theory explanation is that the chain is
% periodic (with period 3)

pause

%% Duel

% Transition matrix for the duel described in class
pa=2/6; qa=1-pa;
pb=3/6; qb=1-pb;
p=[0 qa  pa 0; qb 0 0 pb; 0 0 1 0; 0 0 0 1]
% Initial distribution 
p0=[1 0 0 0]  % We know that A starts
pause
p0*p          % After one step, either B shoots or is hit 
p0*p^2        % After two steps, either A shoots, A is hit or B is hit  
p0*p^3
p0*p^4
p0*p^15
p0*p^16

[v,e]=eig(p)

pause
% Different Initial distribution 
p0=[ 0  1 0 0]  % If B starts instead
pause
p0*p          % After one step, either B shoots or is hit 
p0*p^2        % After two steps, either A shoots, A is hit or B is hit  
p0*p^3
p0*p^4
p0*p^15
p0*p^16


