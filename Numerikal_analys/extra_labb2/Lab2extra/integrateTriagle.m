function [ I ] = integrateTriagle( f, a, b, h )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

I = 0;

g = @(x) fastIntegral(@(y) f(x, y), 0, x/2, h);

x = a:h:b;

for i = x(2:end-1)
    I = I + g(i);
end


I = h * (I + (g(x(1)) + g(x(end)))/2);

end

