%% CGS
M = 1e3;
N = 4000;
mu = 5;
X = exprnd(mu, M, N);
S = cumsum(X, 2);
for k = 1:N
    hist(S(:, k), 30)
    xlabel(num2str(k))
    pause(0.1)
end