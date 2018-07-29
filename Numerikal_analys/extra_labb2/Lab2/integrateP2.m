function [ I ] = integrateP2( f, a, b, h )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
l = b-a;
n = l/h;
n = ceil(n);

if mod(n, 2) == 1
    n = n+1;
end

h = l/n;

sigmaOdd = 0;

for i = 2:2:n+1
    sigmaOdd = sigmaOdd + f(a + (i-1)*h);
end

sigmaEven = 0;

for i = 3:2:n
    sigmaEven = sigmaEven + f(a + (i-1)*h);
end

for i = 3:2:n

I = (l/(3*n))*(f(a) + f(b) + 4*sigmaOdd + 2*sigmaEven);
end

