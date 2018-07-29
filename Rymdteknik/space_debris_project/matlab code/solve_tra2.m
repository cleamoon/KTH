function [dydt] = solve_tra2(t,y)

R_earth=6371e3; % radius of earth in m
g0=9.80665; 
mu=6.67408e-11*6e24;
cd=0.47; % drag coefficient for a sphere
A=pi*(3.66/2)^2; % cross sectional area
isp2=340; % specific impulse of stage 1
tb1=180;
tb2=372; % burn time of stage 1
max_propellant_mass_2=92670; % maximum propellant for stage 1

global gamma1

dydt(1)=(1/y(5))*(g0*isp2*max_propellant_mass_2/tb2-0.5*density(y(4))*y(1)^2*A*cd-y(5)*sin(y(2))*(mu/(R_earth+y(4))^2-(y(1)*cos(y(2)))^2/(R_earth+y(4))));
%dydt(2)=(-1/y(1))*cos(y(2))*(mu/(R_earth+y(4))^2-(y(1)*cos(y(2)))^2/(R_earth+y(4)));
dydt(2)=-cos(y(2))^2*tan(gamma1)/tb2;
dydt(3)=y(1)*cos(y(2));
dydt(4)=y(1)*sin(y(2));
dydt(5)=-max_propellant_mass_2/tb2;
dydt=dydt';



end

