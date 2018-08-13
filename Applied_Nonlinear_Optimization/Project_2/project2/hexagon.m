function [f,gradf,g,A,HessL] = hexagon(x,lambda)

% [f,gradf,g,A,HessL] = hexagon(x,lambda)
%
% This routine gives:
% f                      objective function   
% gradf                  gradient of objective function
% g(i), i=1,...,24       constraint functions
% A                      Jacobaian of constraint functions
% HessL                  Hessian of the Lagrangian function
% ( HessL = Hessf - sum lambda(i) Hessg{i} )
%
% for the problem of maximizing the area of a hexagon subject to the
% conditions that no two of its vertices are more than unit apart, posed 
% on the form
%
% minimize   f(x)
% subject to g_i(x) >= 0, i=1,...,24
%
% with the variables x(1),...,x(9) representing the coordinates of the
% vertices, with orientation described below
%
%          (x(1),x(6)) --- (x(2),x(7))
%         /                           \
%        /                             \
%     (0,0)                          (x(3),0)
%        \                             /   
%         \                           /
%          (x(5),x(9)) --- (x(4),x(8))
%
% M-file written by Anders Forsgren.
% This version dated 4 March 2004.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = 0.5*(-x(2)*x(6)+x(1)*x(7)-x(3)*x(7)-x(5)*x(8)+x(4)*x(9)+x(3)*x(8));

gradf = 0.5*[ x(7)
             -x(6)
             -x(7)+x(8)
              x(9)
             -x(8)
             -x(2)
              x(1)-x(3)
              x(3)-x(5)
              x(4)     ];

Hessf = zeros(9);
Hessf(1,7) =  0.5;
Hessf(2,6) = -0.5;
Hessf(3,7) = -0.5;
Hessf(3,8) =  0.5;
Hessf(4,9) =  0.5;
Hessf(5,8) = -0.5;
Hessf(6,2) = -0.5;
Hessf(7,1) =  0.5;
Hessf(7,3) = -0.5;
Hessf(8,3) =  0.5;
Hessf(8,5) = -0.5;
Hessf(9,4) =  0.5;

g = zeros(24,1);

g(1) = x(1);
gradg{1} = zeros(9,1);
gradg{1}(1)= 1;
Hessg{1} = zeros(9);

g(2) = x(6);
gradg{2} = zeros(9,1);
gradg{2}(6) = 1;
Hessg{2} = zeros(9);

g(3) = x(2)-x(1);
gradg{3} = zeros(9,1);
gradg{3}(1) = -1;
gradg{3}(2) = 1;
Hessg{3} = zeros(9);

g(4) = x(7);
gradg{4} = zeros(9,1);
gradg{4}(7) = 1;
Hessg{4} = zeros(9);

g(5) = x(3)-x(2);
gradg{5} = zeros(9,1);
gradg{5}(2) = -1;
gradg{5}(3) = 1;
Hessg{5} = zeros(9);

g(6) = x(3)-x(4);
gradg{6} = zeros(9,1);
gradg{6}(3) = 1;
gradg{6}(4) = -1;
Hessg{6} = zeros(9);

g(7) = -x(8);
gradg{7} = zeros(9,1);
gradg{7}(8) = -1;
Hessg{7} = zeros(9);

g(8) = x(4)-x(5);
gradg{8} = zeros(9,1);
gradg{8}(4) = 1;
gradg{8}(5) = -1;
Hessg{8} = zeros(9);

g(9) = -x(9);
gradg{9} = zeros(9,1);
gradg{9}(9) = -1;
Hessg{9} = zeros(9);

g(10) = 1-x(1)^2-x(6)^2;
gradg{10} = zeros(9,1);
gradg{10}(1) = -2*x(1);
gradg{10}(6) = -2*x(6);
Hessg{10} = zeros(9);
Hessg{10}(1,1) = -2;
Hessg{10}(6,6) = -2;

g(11) = 1-x(2)^2-x(7)^2;
gradg{11} = zeros(9,1);
gradg{11}(2) = -2*x(2);
gradg{11}(7) = -2*x(7);
Hessg{11} = zeros(9);
Hessg{11}(2,2) = -2;
Hessg{11}(7,7) = -2;

g(12) = 1-x(3);
gradg{12} = zeros(9,1);
gradg{12}(3) = -1;
Hessg{12} = zeros(9);

g(13) = 1-x(4)^2-x(8)^2;
gradg{13} = zeros(9,1);
gradg{13}(4) = -2*x(4);
gradg{13}(8) = -2*x(8);
Hessg{13} = zeros(9);
Hessg{13}(4,4) = -2;
Hessg{13}(8,8) = -2;

g(14) = 1-x(5)^2-x(9)^2;
gradg{14} = zeros(9,1);
gradg{14}(5) = -2*x(5);
gradg{14}(9) = -2*x(9);
Hessg{14} = zeros(9);
Hessg{14}(5,5) = -2;
Hessg{14}(9,9) = -2;

g(15) = 1-(x(1)-x(2))^2-(x(6)-x(7))^2;
gradg{15} = zeros(9,1);
gradg{15}(1) = -2*(x(1)-x(2));
gradg{15}(2) =  2*(x(1)-x(2));
gradg{15}(6) = -2*(x(6)-x(7));
gradg{15}(7) =  2*(x(6)-x(7));
Hessg{15} = zeros(9);
Hessg{15}(1,1) = -2;
Hessg{15}(1,2) =  2;
Hessg{15}(2,1) =  2;
Hessg{15}(2,2) = -2;
Hessg{15}(6,6) = -2;
Hessg{15}(6,7) =  2;
Hessg{15}(7,6) =  2;
Hessg{15}(7,7) = -2;

g(16) = 1-(x(1)-x(3))^2-x(6)^2;
gradg{16} = zeros(9,1);
gradg{16}(1) = -2*(x(1)-x(3));
gradg{16}(3) =  2*(x(1)-x(3));
gradg{16}(6) = -2*x(6);
Hessg{16} = zeros(9);
Hessg{16}(1,1) = -2;
Hessg{16}(1,3) =  2;
Hessg{16}(3,1) =  2;
Hessg{16}(3,3) = -2;
Hessg{16}(6,6) = -2;

g(17) = 1-(x(1)-x(4))^2-(x(6)-x(8))^2;
gradg{17} = zeros(9,1);
gradg{17}(1) = -2*(x(1)-x(4));
gradg{17}(4) =  2*(x(1)-x(4));
gradg{17}(6) = -2*(x(6)-x(8));
gradg{17}(8) =  2*(x(6)-x(8));
Hessg{17} = zeros(9);
Hessg{17}(1,1)= -2;
Hessg{17}(1,4)=  2;
Hessg{17}(4,1)=  2;
Hessg{17}(4,4)= -2;
Hessg{17}(6,6)= -2;
Hessg{17}(6,8)=  2;
Hessg{17}(8,6)=  2;
Hessg{17}(8,8)= -2;

g(18) = 1-(x(1)-x(5))^2-(x(6)-x(9))^2;
gradg{18} = zeros(9,1);
gradg{18}(1) = -2*(x(1)-x(5));
gradg{18}(5) =  2*(x(1)-x(5));
gradg{18}(6) = -2*(x(6)-x(9));
gradg{18}(9) =  2*(x(6)-x(9));
Hessg{18} = zeros(9);
Hessg{18}(1,1) = -2;
Hessg{18}(1,5) =  2;
Hessg{18}(5,1) =  2;
Hessg{18}(5,5) = -2;
Hessg{18}(6,6) = -2;
Hessg{18}(6,9) =  2;
Hessg{18}(9,6) =  2;
Hessg{18}(9,9) = -2;

g(19) = 1-(x(2)-x(3))^2-x(7)^2;
gradg{19} = zeros(9,1);
gradg{19}(2) = -2*(x(2)-x(3));
gradg{19}(3) =  2*(x(2)-x(3));
gradg{19}(7) = -2*x(7);
Hessg{19} = zeros(9);
Hessg{19}(2,2)= -2;
Hessg{19}(2,3)=  2;
Hessg{19}(3,2)=  2;
Hessg{19}(3,3)= -2;
Hessg{19}(7,7)= -2;

g(20) = 1-(x(2)-x(4))^2-(x(7)-x(8))^2;
gradg{20} = zeros(9,1);
gradg{20}(2) = -2*(x(2)-x(4));
gradg{20}(4) =  2*(x(2)-x(4));
gradg{20}(7) = -2*(x(7)-x(8));
gradg{20}(8) =  2*(x(7)-x(8));
Hessg{20} = zeros(9);
Hessg{20}(2,2) = -2;
Hessg{20}(2,4) =  2;
Hessg{20}(4,2) =  2;
Hessg{20}(4,4) = -2;
Hessg{20}(7,7) = -2;
Hessg{20}(7,8) =  2;
Hessg{20}(8,7) =  2;
Hessg{20}(8,8) = -2;

g(21) = 1-(x(2)-x(5))^2-(x(7)-x(9))^2;
gradg{21} = zeros(9,1);
gradg{21}(2) = -2*(x(2)-x(5));
gradg{21}(5) =  2*(x(2)-x(5));
gradg{21}(7) = -2*(x(7)-x(9));
gradg{21}(9) =  2*(x(7)-x(9));
Hessg{21} = zeros(9);
Hessg{21}(2,2) = -2;
Hessg{21}(2,5) =  2;
Hessg{21}(5,2) =  2;
Hessg{21}(5,5) = -2;
Hessg{21}(7,7) = -2;
Hessg{21}(7,9) =  2;
Hessg{21}(9,7) =  2;
Hessg{21}(9,9) = -2;

g(22) = 1-(x(3)-x(4))^2-x(8)^2;
gradg{22} = zeros(9,1);
gradg{22}(3) = -2*(x(3)-x(4));
gradg{22}(4) =  2*(x(3)-x(4));
gradg{22}(8) = -2*x(8);
Hessg{22} = zeros(9);
Hessg{22}(3,3) = -2;
Hessg{22}(3,4) =  2;
Hessg{22}(4,3) =  2;
Hessg{22}(4,4) = -2;
Hessg{22}(8,8) = -2;

g(23) = 1-(x(3)-x(5))^2-x(9)^2;
gradg{23} = zeros(9,1);
gradg{23}(3) = -2*(x(3)-x(5));
gradg{23}(5) =  2*(x(3)-x(5));
gradg{23}(9) = -2*x(9);
Hessg{23} = zeros(9);
Hessg{23}(3,3) = -2;
Hessg{23}(3,5) =  2;
Hessg{23}(5,3) =  2;
Hessg{23}(5,5) = -2;
Hessg{23}(9,9) = -2;

g(24) = 1-(x(4)-x(5))^2-(x(8)-x(9))^2;
gradg{24} = zeros(9,1);
gradg{24}(4) = -2*(x(4)-x(5));
gradg{24}(5) =  2*(x(4)-x(5));
gradg{24}(8) = -2*(x(8)-x(9));
gradg{24}(9) =  2*(x(8)-x(9));
Hessg{24} = zeros(9);
Hessg{24}(4,4) = -2;
Hessg{24}(4,5) =  2;
Hessg{24}(5,4) =  2;
Hessg{24}(5,5) = -2;
Hessg{24}(8,8) = -2;
Hessg{24}(8,9) =  2;
Hessg{24}(9,8) =  2;
Hessg{24}(9,9) = -2;

A = [];

HessL = Hessf;
for i=1:24
  HessL = HessL-lambda(i)*Hessg{i};
  A(i,:) = gradg{i}';
end
