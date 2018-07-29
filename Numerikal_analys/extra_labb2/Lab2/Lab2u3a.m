f = @(x)(1-1/pi*atan(x-1))./(2-cos(pi*x));
a = 0;
b = 2.6;

%Trappets har tre tillförlitliga decimaler, Simpson har fyra.

format long

disp('Trappets')
h = 0.1;
I01 = integrateP1(f, a, b, h)

h = 0.05;
I005 = integrateP1(f, a, b, h)

disp('Differans')
abs(I01- I005)

disp('Simpson')
h = 0.1;
I01 = integrateP2(f, a, b, h)

h = 0.05;
I005 = integrateP2(f, a, b, h)

disp('Differans')
abs(I01- I005)

format