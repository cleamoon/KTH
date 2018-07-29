function [ I ] = fastIntegral( f, a, b, h )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

maxN = 10^7;
len = b-a;
n = ceil(len/h);
h = len/n;
k = ceil(n/maxN);
cuts = linspace(a, b, k+1);

I = 0;
for i = 1:k
    I =  I + fastP1(f, cuts(i), cuts(i+1), h);
end

end

