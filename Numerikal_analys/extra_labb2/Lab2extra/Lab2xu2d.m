%Volume
v = 1.2^10;

ref = 6.231467927023725;

%Iterations
n = 10^9;

%Maximum number of random values in memory at the same time
r = 10^6;

dMax = 1.2;
d = 10;
I = 0;
m = n/r;

x = zeros(1, m);
f = zeros(1, m);

tic

for i = 1:m
    rnd = dMax*rand([d, r]);
    I = I + sum(exp(prod(rnd)));
    x(i) = i*r;
    f(i) = 1/x(i)*v*I;
end

I = 1/n*v*I

toc

plot(x, f)


figure

loglog(x, abs(f-ref))
hold on;
loglog(x, 1./sqrt(x)/10, 'k')
