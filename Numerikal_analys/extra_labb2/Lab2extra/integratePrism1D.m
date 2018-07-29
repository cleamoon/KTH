function [ I ] = integratePrism1D( f, a, b, h )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

I = 0;

g = @(z) integrateTriagle(@(x, y) f(x, y, z), a(1), b(1), h);

z = a(2):h:b(2);

for i = z(2:end-1)
    I = I + g(i);
end


I = h * (I + (g(z(1)) + g(z(end)))/2);

end

