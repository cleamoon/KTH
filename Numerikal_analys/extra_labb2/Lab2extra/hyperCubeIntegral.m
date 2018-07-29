function [ I ] = hyperCubeIntegral( f, a, b, h, dim )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

I = 0;

if dim == 2
    g = @(x) fastIntegral(@(y) f(x*y), a, b, h);
else
    g = @(x) hyperCubeIntegral(@(y) f(x*y), a, b, h, dim-1);
end

len = b-a;
n = ceil(len/h);

z = linspace(a, b, n+1);

for i = z(2:end-1)
    I = I + g(i);
    if dim == 10
        disp('ok')
    end
end


I = len/n * (I + (g(z(1)) + g(z(end)))/2);

end

