function [x,lambda,f,gradf,g,A,HessL] = sqp(prob,x,lambda)
% function [x,lambda,f,gradf,g,A,HessL] = sqp(prob,x,lambda);
%
% solves the problem
% 
% minimize   f(x)
% subject to g_i(x) >= 0, i=1,...,m
%
% The input variable prob points to an m file that provides problem
% data for each iteration on the form
%
% [f,gradf,g,A,HessL] = ex512(x,lambda)
%
% where
%
% f           Objective function
% gradf       Objective function gradient
% g           Constraint function
% A           Constraint Jacobian
% HessL       Hessian of Lagrangian function
% ( HessL = Hessf - sum lambda(i) Hessg{i} )
%
% at a given point (x,lambda)


% At each iteration, compute problem data for the problem specified
% by prob.

[f,gradf,g,A,HessL] = feval(prob,x,lambda);
[p, ~, l] = qp(A, -g, gradf, HessL, p, p, 1);
x = x + p(:, end);
l = l(:, end);
lambda = l;
if (norm(p) > 10^-8)
    [x,lambda,f,gradf,g,A,HessL] = sqp(prob,x,lambda);
end