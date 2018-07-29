function plot_mvnpdf(mux, muy, sigmax, sigmay, rho)
if rho >= 1
    error('rho must be in [-1, 1]')
end
mu = [mux muy];
sigma = [sigmax rho; rho sigmay];
n = 100;
mystartx = mux + (1.5*sigmax)^2;
myendx = mux - (1.5*sigmax)^2;
x = linspace(mystartx, myendx, n);
mystarty = muy + (1.5*sigmay)^2;
myendy = muy - (1.5*sigmay)^2;
y = linspace(mystarty, myendy, n);

z = zeros(n);

for k = 1:n
    z(k, :) = mvnpdf([x' y(k)*ones(n, 1)], mu, sigma);
end
% 
% subplot(221)
% plot(x, normpdf(x, mux, sigmax))
% xlabel('Density function of X')
% 
% subplot(222)
% plot(y, normpdf(y, muy, sigmay))
% xlabel('Density function of Y')
% 
% subplot(212)
surf(x, y, z)
% shading interp
xlabel('Joint density function of X and Y')
colormap('jet')
% keyboard
end