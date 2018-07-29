function [ I ] = integratePrism( f, a, b, h )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

I = 0;

g = @(z) trapezoidal2D(@(x, y) f(x, y, z), a(1:2), b(1:2), h);

z = a(3):h:b(3);

for i = z(2:end-1)
    I = I + g(i);
end


I = h * (I + (g(z(1)) + g(z(2)))/2);

end

