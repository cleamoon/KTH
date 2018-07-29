%% Problem 1: exp-pdf
dx = 0.1;
x = 0:dx:15;
mu = 1;
y = exppdf(x, mu);
plot(x,y)
