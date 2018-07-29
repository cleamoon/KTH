%% Problem 1: lambda-plot
lambda = 0.4267;
f=(lambda*exp(-x/lambda)+lambda./x).*(x >= 1 & x <= 10);
plot(x, f)