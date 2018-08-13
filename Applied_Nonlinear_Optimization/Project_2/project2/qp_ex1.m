%% Example taken from the slides lecture 8
clear variables
close all
clc

%%
% Function to solve the problem
%                        minimize     c'x + 0.5 x'H x
%                        subject to   A x -s = b
%                                     s >= 0
% using an interior point method
% "l" are the lagrangian multipliers

A=[ 1  0
    0  1 
   -1 -1
    1 -5];
b=[0 0 -7 -25].';
c=[-3 -36].';
H=[2 1
   1 4];
x=[0 0].';
l=ones(length(A),1);
mu=1;

[x,s,l] = qp_algorithm(A,b,c,H,x,l,mu);


u=ones(size(l));

%% FoNoc

     % feasibility A*x>=b --> A*x-b>=0
     
     feas=A*x-b
     
     % relation with the gradient    grad(f)=A.'*l --> H*x+c-A.'*l=0  
     % it is verified only in an approximate way, because we are using an
     % interior point method
     
     gradErr=H*x+c-A.'*l
     
     % Complementarity   l.'*s=0
     % it is verified only in an approximate way, because we are using an
     % interior point method
     
     compl=l.'*s
 
