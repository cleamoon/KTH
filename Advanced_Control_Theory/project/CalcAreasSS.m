function [ a1, a2, a3, a4 ] = CalcAreasSS( h1, h2, h3, h4, k1, k2, u1, u2, gamma)
%CalcAras Calculate output areas based on stady state heights
%   h1 - h4 Steady state heights in tanks
%   k1, k2 Voltage flow koefficient
%   u1, u2 Voltage
%   gamma1, gamma2 Flow division

g = 9.81;
q1 = k1.*u1; % Flow from pump 1
q2 = k2.*u2; % Flow from pump 2

a1 = 1./sqrt(2.*h1.*g).*((1-gamma).*q2 + gamma.*q1);
a2 = 1./sqrt(2.*h2.*g).*((1-gamma).*q1 + gamma.*q2);
a3 = 1./sqrt(2.*h3.*g).*(1-gamma).*q2;
a4 = 1./sqrt(2.*h4.*g).*(1-gamma).*q1;

a1 = mean(a1);
a2 = mean(a2);
a3 = mean(a3);
a4 = mean(a4);

end
