%% Stora talens lag
mu = 0.5;
M = 500;
X = exprnd(mu, M, 1);
plot(ones(M, 1)*mu, 'r-.')
hold on
for k = 1:M
    plot(k, mean(X(1:k)))
    if k == 1
        legend('Sant \mu', 'Skattning av \mu')
    end
    xlabel(num2str(k)), pause(0.001)
end
hold off