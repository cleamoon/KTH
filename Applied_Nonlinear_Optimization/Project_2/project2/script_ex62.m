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
% This function is for Example 6.2 in the SF2822 exercise booklet



function [f,gradf,g,A,HessL] = ex62(x,lambda)

% f(x)=e^(x1+x2)+x1^2+x1*x2+2*x2^2+x1
f = exp(x(1)+x(2))+x(1)^2+x(1)*x(2)+2*x(2)^2+x(1);

% g1(x)=10-x1^2-x2^2
g(1,1) = 10-x(1)^2-x(2)^2;

% g2(x)=x2-1
g(2,1)=x(2)-1;



gradf=[exp(x(1)+x(2))+2*x(1)+x(2)+1;
          exp(x(1)+x(2))+x(1)+4*x(2) ];
      
Hessf=[exp(x(1)+x(2))+2,  exp(x(1)+x(2))+1;
      exp(x(1)+x(2))+1, exp(x(1)+x(2))+4];

n = length(x);


gradg{1} = [ -2*x(1); -2*x(2)];

Hessg{1} = [-2 0; 0 -2];
         
         
gradg{2} = [ 0 ;1 ];

Hessg{2} = [0 0; 0 0];

m = length(g);

A = [];

HessL = Hessf;
for i=1:m
  HessL = HessL-lambda(i)*Hessg{i};
  A(i,:) = gradg{i}';
end

end
