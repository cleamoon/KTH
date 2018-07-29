v = 1.2^10;
n = 10^9;
r = 10^6;
dMax = 1.2;
d = 10;

I = 0;

m = n/r;

tic

for i = 1:m
    rnd = dMax*rand([d, r]);
    I = I + sum(exp(prod(rnd)));
end

I = 1/n*v*I

toc