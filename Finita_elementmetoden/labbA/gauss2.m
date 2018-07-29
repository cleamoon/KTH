function res = gauss2(f, a, b)
res = 0;
m = 20;
h = (b-a)/m;
x0 = a;
x1 = a+h;
for i = 1:m
    xi0 = (x0+x1)/2-sqrt(3)/6*h;
    xi1 = (x0+x1)/2+sqrt(3)/6*h;
    res = res + h/2*(f(xi0)+f(xi1));
    x0 = x0+h;
    x1 = x1+h;
end

