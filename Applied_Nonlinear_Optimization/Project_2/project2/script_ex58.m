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
% This function is for Example 5.8 in the SF2822 exercise booklet



function [f,gradf,g,A,HessL] = ex58(x,lambda)

% f(x)=e^(x1+x2)+x1^2+x1*x2+2*x2^2+x1
f = 1/2*(x(1)+1)^2+1/2*(x(2)+2)^2;

% g1(x)=10-x1^2-x2^2
g(1,1) = 6-3*(x(1)+x(2)-2)^2-(x(1)-x(2))^2;
% g2(x)=x2-1
g(2,1)=x(1);
g(3,1)=x(2);




gradf=[x(1)+1; x(2)+2 ];
n = length(x);
      
Hessf=eye(n);




gradg{1} = [-4*(2*x(1)+x(2)-3);  -4*(x(1)+2*x(2)-3)];

Hessg{1} = [-8 -4; -4 -8];
         
         
gradg{2} = [1; 0 ];

Hessg{2} = [0 0; 0 0];

gradg{3} = [0 ;1];

Hessg{3} = [0 0; 0 0];

m = length(g);

A = [];

HessL = Hessf;
for i=1:m
  HessL = HessL-lambda(i)*Hessg{i};
  A(i,:) = gradg{i}';
end



