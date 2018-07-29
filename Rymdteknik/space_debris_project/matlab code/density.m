function rho = density(x)

R_earth=6371e3; % radius of earth in m
g0=9.80665; 
p_ssl=101.325e3;
T_ssl=288.15;
rho_ssl=1.225; %in kg/m^3
mu=6.67408e-11*6e24;
R=p_ssl/(rho_ssl*T_ssl);

rho=rho_ssl*exp(-(g0/(R*T_ssl))*x);


end

