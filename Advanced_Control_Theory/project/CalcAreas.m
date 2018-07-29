function [ a ] = CalcAreas( h, k, u)
%CalcAras Calculate output areas based on stady state heights
%  h Steady state heights in tank
%  k Voltage flow koefficient
%  u Voltage

g = 9.81;
q = k.*u; % Flow from pump i
a = 1./sqrt(2.*h.*g).*q;
end


