y = [2.28E-06 1.89E-06 2.35E-06 2.1E-06 2.1E-06 2.18E-06 1.98E-06 2.08E-06 1.88E-06 2.12E-06 2.04E-06 2.04E-06 1.97E-06 1.79E-06 2.12E-06 1.94E-06 1.9E-06 1.88E-06 1.88E-06 2.08E-06 1.5E-06 2.19E-06 1.62E-06 1.88E-06];
y = y*10^8;
s = size(y)*[0 1]';
x = [1:s];
plot(x, y, '*');
hold on;
fit = polyfit(x,y,1)
ra = [0:0.2:s+3];
plot(ra, fit*[1 0]'*ra + fit*[0 1]', '.');
title('Wavenumber difference plot')
xlabel('Quantum number v')
ylabel('Difference in wavenumber [1/cm]')
