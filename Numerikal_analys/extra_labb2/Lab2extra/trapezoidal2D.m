function [ I ] = trapezoidal2D( f, a, b, h )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

lenx = b(1)-a(1);
leny = b(2)-a(2);
nx = ceil(lenx/h);
ny = ceil(leny/h);

x = linspace(a(1), b(1), nx+1);
y = linspace(a(2), b(2), ny+1);

I1 = f(a(1), a(2)) + f(a(1), b(2)) + f(b(1), a(2)) + f(b(1), b(2));
I2 = sum( f(x(2:end-1), a(2)) ) + sum( f(x(2:end-1), b(2)) ) + sum( f(a(1), y(2:end-1)) ) + sum( f(b(1), y(2:end-1)) );
I3 = 0;

for i = 2:nx
    I3 = I3 + sum( f(x(i), y(2:end-1)) );
end

I = (lenx/nx)*(leny/ny)*( I1/4 + I2/2 + I3 );

end

