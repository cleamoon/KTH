L = 8880*1000;  % The length of the whole flight
m = 230900;  % mass of the airplane
%cd0 = 0.044;  % c_D0 of the airplane
%k=0.072271666782024;
cd0 = 0.01749533;
k = 0.04559;  % k of the airplane
S = 363.10;
h = 39000*0.3048;  % the cruise altitude of the airplane 
R = 6356.766*1000; % radius of the earth  
g0 = 9.80665; 
g = g0 * R^2/(R+h)^2; % gravitation acceleration

ct = 15.5/1000/1000*g;


V = 465*1.852/3.6;
[T, a, P, rho] = atmosisa(h);  % air density where the airplane cruising assuming ISA
%clcd = (1/2/sqrt(cd0*k));  % maximum c_l/c_d
R1 = 0.970;
R2 = 0.985;
m2 = m * R1 * R2; % airplane mass while cruising
R4 = 0.995;
% R3 = exp(L/(1/ct*sqrt(2*m2*g/rho2/S)*clcd));
% R3 = exp(-L/(V/ct*clcd));
% clcd = (cd0/3/k)^(1/4)*3/4/cd0;

clcd = (2*m2*g/rho/S)^(1/2)*(cd0*V+k*(2*m2*g/rho/S)^2*V^(-2*(2-1/2)))^(-1);

R3 = exp(-L*ct/sqrt(2*m2*g/rho/S)/clcd);
mf = m*1.06*(1-R1*R2*R3*R4)