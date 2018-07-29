clf
n = 13;
h = 0.1*2.^-(1:n);
f = @(x)(1-1/pi*atan(x-1))./(2-cos(pi*x));
a = 0;
b = 2.6;

format long
ref = integrateP2(f, a, b, 10^-6);

t = zeros(size(h));
s = zeros(size(h));
I = zeros(size(h));

for i = 1:n
    t(i) = abs(integrateP1(f, a, b, h(i)) - ref);
    I(i) = integrateP2(f, a, b, h(i));
    s(i) = abs(I(i) - ref);
end

loglog(h, t)
hold on;
loglog(h, s, 'k')
setGrid()

for i = 1:n-4
    kvot = (I(i)-I(i+1))/(I(i+1)-I(i+2))
    konvergens = log2(abs(kvot))
end