a=[4047	4358	5461	5780	8094	8716	10922	11560];
b=[617	673	867	947	1387	1505	1913	2035];
equ = polyfit(b,a,1);
range = [0:50:2500];
plot(b,a, '*');
hold on;
plot(range, equ*[1 0]'*range+equ*[0 1]', '.');
title('Calibration')
xlabel('Channel number')
ylabel('Wavelength')
