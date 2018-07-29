function [ I ] = monteCarloIntegraton( dMax, dMin, v, n )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

d = size(dMax, 1);

I = 0;

m = n/100;

for i = 1:n
    rnd = dMin+(dMax-dMin).*rand([d, 1]);
    I = I + exp(prod(rnd));
    
    if mod(i, m) == 0
        fprintf('%.f percent\n', i/m)
    end
    
end

I = 1/n*v*I;

end

