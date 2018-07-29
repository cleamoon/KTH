function [ I ] = integrateP1( f, a, b, h )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
l = b-a;
n = l/h;
n = ceil(n);
h = l/n;

sigma = 0;

for i = 2:n
    sigma = sigma + f(a+(i-1)*h);
end


I = l/n*((f(a) + f(b))/2 + sigma);
end

