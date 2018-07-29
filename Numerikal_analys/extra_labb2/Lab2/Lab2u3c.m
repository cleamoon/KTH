x = linspace(0, 3, 1000);
a = 0;
b = 2.6;
%p = 1
f = @(x)(1-1/pi*atan(x-1))./(2-cos(pi*x));
%Create a reference solution
ref = quad(f, a, b, 10^-14);

%Calculate the integral with quad
[quadI, n] = quad(f, a, b, 10^-6);
%Calculate the distance for simpson's rule
h = (b-a)/n;
simpsonI = integrateP2(f, a, b, h);

disp('p = 1')
errorQuad = abs(quadI - ref)
errorSimpsonv = abs(simpsonI - ref)

plot(x, f(x))
title('p = 1')

%p = 1000
f = @(x)(1-1/pi*atan(10^3*(x-1)))./(2-cos(pi*x));

%Create a reference solution
ref = quad(f, a, b, 10^-14);
%Calculate the integral with quad
[quadI, n] = quad(f, a, b, 10^-6);
%Calculate the distance for simpson's rule
h = (b-a)/n;
simpsonI = integrateP2(f, a, b, h);

disp('p = 1000')
errorQuad = abs(quadI - ref)
errorSimpsonv = abs(simpsonI - ref)

figure
plot(x, f(x))
title('p = 10^3')