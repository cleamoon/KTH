% Function for computing 
%
% f           Objective function
% gradf       Objective function gradient
% g           Constraint function
% A           Constraint Jacobian
% HessL       Hessian of Lagrangian function
% ( HessL = Hessf - sum lambda(i) Hessg{i} )
%
% at a given point (x,lambda)
%
% This function is for Example 5.4 in the SF2822 exercise booklet


function [f,gradf,g,A,HessL]  = script_ex54(x,lambda)

%f = 4*(x1-2)^2+(x2-1)^2

f=4*(x(1)-2)^2+(x(2)-1)^2;

%grad(f)=[ 8*x1-16; 2*x2-2]

gradf=[8*x(1)-16; 2*x(2)-2];

%Hess(f)= [8 0; 0 2];

Hessf=[8 0; 0 2];



% g1(x)=1-x1^2-x2^2

g(1,1) = 1-x(1)^2-x(2)^2;

% grad(g1)= [-2x1; -2x2];

gradg{1}=[-2*x(1); -2*x(2)];

% Hessg1=[-2 0; 0 -2];

Hessg{1}=[-2 0; 0 -2];



% g2(x)=4-x1^2-(x2-2)^2

g(2,1) = 4-x(1)^2-(x(2)-2)^2;

% grad(g2)= [-2x1; -2x2+4];

gradg{2}=[-2*x(1); -2*x(2)+4];

% Hessg2=[-2 0; 0 -2];

Hessg{2}=[-2 0; 0 -2];




m = length(g);

A = [];

HessL = Hessf;
for i=1:m
  HessL = HessL-lambda(i)*Hessg{i};
  A(i,:) = gradg{i}';
end

end

