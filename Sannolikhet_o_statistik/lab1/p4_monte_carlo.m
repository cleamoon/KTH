%% P4_monte_carlo
N = 1e5;
X = rand(N, 1)*2*pi;
Y = rand(N, 1);
mean((exp(X)).^(cos(Y)))