function [nx, par_JF] = Ufit_JF(X, Ux)

% Fit to the theoretical curve
par0 = [10 0.1] ; % Initial guess
par_JF = fminsearch(@(par) FSpar_JF(par, X, Ux), par0) ;

CC = par_JF(1) ;
nx = par_JF(2) ;

figure(20), clf
plot(X, Ux, 'bo'), hold on
xlabel('x   (m)'), ylabel('U_e   (m/s)')

figure(20), hold on
plot(X, CC*(X).^nx, 'r-'), hold on
title('Free-stream velocity variation with the downstream direction')