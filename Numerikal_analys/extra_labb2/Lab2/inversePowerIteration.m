function [ e, n ] = inversePowerIteration( A, x, epsilon )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

prevE = inf(1);
error = inf(1);
n = 0;

while error > epsilon
    v = x/norm(x);
    x = A\v;
    e = v'*x;
    error = abs(prevE - e);
    prevE = e;
    n = n+1;
end

e = 1/e;

end

