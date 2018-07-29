clc
clear
l1=4500;    % element 1 length
l2=4500;   % element 2 length
l3=5000;    % element 3 length
E=210000;   % Youngs Modulus
I1=55047467;  % Moment of Inertia
I2=35094542;     % Moment of Inertia 
P=-60000;    % Force
A=4401;     % Cross section area





%% b) pinned at point 2
t=E*A/l3     % vertical beams's axial stiffness
r=4*E*I2/l3  % vertical beams's rotation stiffness

%Stiffness matrix for element 1
K1=(E*I1)/l1.^3.*[12 6*l1 -12 6*l1
    6*l1 4*l1.^2 -6*l1 2*l1.^2
    -12 -6*l1 12 -6*l1
    6*l1 2*l1.^2 -6*l1 4*l1.^2]


%Stiffness matrix for element 2 is not complete, you have to take into account 
% the vertical beam axial and vertical stiffnes. Put the missing values in to the right place!
K2=(E*I1)/l2.^3.*[12 6*l2 -12 6*l2
    6*l2 4*l2.^2 -6*l2 2*l2.^2
    -12 -6*l2 12 -6*l2
    6*l2 2*l2.^2 -6*l2 (4*l2.^2)]

%Stiffness matrix in global coordinate system
Kg=[K1(1,1) K1(1,2) K1(1,3) K1(1,4) 0 0
    K1(2,1) K1(2,2) K1(2,3) K1(2,4) 0 0
    K1(3,1) K1(3,2) K1(3,3)+K2(1,1) K1(3,4)+K2(1,2) K2(1,3) K2(1,4)
    K1(4,1) K1(4,2) K1(4,3)+K2(2,1) K1(4,4)+K2(2,2) K2(2,3) K2(2,4)
    0 0 K2(3,1) K2(3,2) K2(3,3) K2(3,4)
    0 0 K2(4,1) K2(4,2) K2(4,3) K2(4,4)]

%Reduced global stiffness matrix
Kred=[K1(2,2) K1(2,3) K1(2,4) 0 0
    K1(3,2) K1(3,3)+K2(1,1) K1(3,4)+K2(1,2) K2(1,3) K2(1,4)
    K1(4,2) K1(4,3)+K2(2,1) K1(4,4)+K2(2,2) K2(2,3) K2(2,4)
    0 K2(3,1) K2(3,2) K2(3,3)+t K2(3,4)
    0 K2(4,1) K2(4,2) K2(4,3) K2(4,4)+r]

%Force vector, do it yourself!
F=[0 -60000 0 0 0]'

%Solve displacement
u=Kred^-1*F


%% %% a) rigid at point 2

a=4500;
b=4500;
K=((E*I1)/(a^3))*[4*a^2 -6*a 2*a^2; -6*a 24 0; 2*a^2 0 8*a^2];
KK=inv(K)
F=[0; -60000; 0]
Dif=KK*F
