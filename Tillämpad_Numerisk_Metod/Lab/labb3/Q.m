%%%Qfunk
function [ Q ] = Q( z,a,b,Q0 )
%C3 numerical methods
if z > a && z < b
    Q=Q0*sin(pi*(z-a)/(z-b));
else
    Q=0;
end
end
    