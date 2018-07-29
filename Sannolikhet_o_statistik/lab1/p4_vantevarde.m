%% Monte Carlo
N = 1e5;
U = rand(N, 1)*2*pi;
mean(sin(U).^2)