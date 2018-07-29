function [ I ] = fastP1( f, a, b, h )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

len = b-a;
n = ceil(len/h);

x = linspace(a, b, n+1);

I = len/n*((f(b)+f(a))/2 + sum(f(x(2:end-1))));

end

