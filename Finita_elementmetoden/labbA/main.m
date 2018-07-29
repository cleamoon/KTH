%% Initialization 
clc, clear; 

%% Problem 2
% Function handles
f = @(x) 8*pi^2*sin(2*pi*x);
faii = @(h, ~) 2/h;
faij = @(h, i, j) -1/h;
fbi = @(f, h, fint, i) fint((@(x) (x-h*i+h)/h*f(x)), h*i-h, h*i)+ fint((@(x) (h*i+h-x)/h*f(x)), h*i, h*i+h);
u = @(x) 2*sin(2*pi*x);
% Computing
h = 0.1;
n = h:h:1-h;
res = fem(faii, faij, fbi, f, h, @gauss2);
% Plotting
figure();
hold on;
title('FEM result computed with different integral method')
xlabel('x')
ylabel('u')
plot(n, res, 'r*--');
plot(0.001:0.001:0.999, u(0.001:0.001:0.999), 'g');
legend('FEM', 'Exact', 'Location', 'northeast');


%% Problem 3
% Function handles
f = @(x) 8*pi^2*sin(2*pi*x);
faii = @(h, ~) 2/h;
faij = @(h, i, j) -1/h;
fbi = @(f, h, fint, i) fint((@(x) (x-h*i+h)/h*f(x)), h*i-h, h*i)+ fint((@(x) (h*i+h-x)/h*f(x)), h*i, h*i+h);
u = @(x) 2*sin(2*pi*x);
% Computing
h = 0.1;
n = h:h:1-h;
res1 = fem(faii, faij, fbi, f, h, @gauss2);
res2 = fem(faii, faij, fbi, f, h, @compMid);
% Plotting
figure();
hold on;
title('FEM result computed with different integral method')
xlabel('x')
ylabel('u')
plot(n, res1, 'r*--');
plot(n, res2, 'bo-.');
plot(0.001:0.001:0.999, u(0.001:0.001:0.999), 'g');
legend('Gauss quadrature', 'Composite midpoint', 'Exact', 'Location', 'northeast');

%% Problem 4 & 5
% Function handles
f = @(x) 8*pi^2*sin(2*pi*x);
faii = @(h, ~) 2/h;
faij = @(h, i, j) -1/h;
fbi = @(f, h, fint, i) fint((@(x) (x-h*i+h)/h*f(x)), h*i-h, h*i)+ fint((@(x) (h*i+h-x)/h*f(x)), h*i, h*i+h);
u = @(x) 2*sin(2*pi*x);
% Computing
l = 2:6;
ehl2 = zeros(size(l)*[0 1]', 1);
for i = l
    h = 2^(-i);
    res = fem(faii, faij, fbi, f, h, @gauss2);
    % ehl2(i-1) = norm(res'-u(h:h:1-h));
    ehl2(i-1) = (integral(@(X)((interp1(h:h:1-h, res, X)-u(X)).^2), h, 1-h))^(1/2);
end
figure();
loglog(2.^(-l), ehl2);
grid on;
title('Convergence study')
xlabel('Step size h')
ylabel('L^2 norm of error e_h')
disp('Errors:')
disp(ehl2);
disp('Order of convergence:')
disp((log(ehl2(end))-log(ehl2(end-1)))/(log(2^-l(end))-log(2^-l(end-1))))

%% Problem 6
% Function handles
f = @(x) 9/16*4*pi*2*sin(3/4*2*pi*x);
faii = @(h, ~) 2/h;
faij = @(h, ~, ~) -1/h;
fbi = @(f, h, fint, i) fint((@(x) (x-h*i+h)/h*f(x)), h*i-h, h*i)+ fint((@(x) (h*i+h-x)/h*f(x)), h*i, h*i+h);
u = @(x) (2*sin((3*pi*x)/2))/pi;
% Computing
l = 7:-1:2;
h = 2^-8;
uend = fem2(faii, faij, fbi, f, h, @compMid);
figure();
hold on;
plot(h:h:1, uend, 'r--');
plot(0.001:0.001:0.999, u(0.001:0.001:0.999), 'g-.');
title('Computation results of the new equations')
xlabel('x')
ylabel('u')
legend('FEM', 'Exact', 'Location', 'northeast')
le = [];
for i=l
    h = 2^(-i);
    res = fem2(faii, faij, fbi, f, h, @gauss2);
%    figure()
%     hold on;
%     plot(h:h:1, res, 'r*');
%     plot(0.001:0.001:0.999, u(0.001:0.001:0.999), 'g')
    % le = [le norm(res'-u(h:h:1))];
    le = [le (integral(@(X)((interp1(h:h:1, res, X)-u(X)).^2), h, 1))^(1/2)];
end
figure();
loglog(2.^(-l), le);
grid on;
title('Convergence study')
xlabel('Step size h')
ylabel('L^2 norm of error e_h')
disp('Errors:')
disp(le);
disp('Order of convergence:')
disp((log(le(end-1))-log(le(1)))/(log(2^-l(end-1))-log(2^-l(1))))
