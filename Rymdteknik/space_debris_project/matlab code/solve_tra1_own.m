function [dydt] = solve_tra1_own(t,y)

R_earth=6371e3; % radius of earth in m
g0=9.80665; 
mu=6.67408e-11*6e24;
cd=0.47; % drag coefficient for a sphere
A=pi*(3.66/2)^2; % cross sectional area
isp1=311; % specific impulse of stage 1
tb1=180; % burn time of stage 1
max_propellant_mass_1=395700; % maximum propellant for stage 1
exit_velocity_1=3008;
exit_pressure_1=0.623e5;
Ae=pi*0.5^2;



dydt(1)=(1/y(5))*((exit_velocity_1*max_propellant_mass_1/tb1)+9*Ae*(exit_pressure_1-pressure(y(4)))-0.5*density(y(4))*y(1)^2*A*cd-y(5)*sin(y(2))*(mu/(R_earth+y(4))^2-(y(1)*cos(y(2)))^2/(R_earth+y(4))));
dydt(2)=(-1/y(1))*cos(y(2))*(mu/(R_earth+y(4))^2-(y(1)*cos(y(2)))^2/(R_earth+y(4)));
dydt(3)=y(1)*cos(y(2));
dydt(4)=y(1)*sin(y(2));
dydt(5)=-max_propellant_mass_1/tb1;
dydt=dydt';


end

