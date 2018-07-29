%% Initialization
clear, clc;

%% Part 3 and 4
alpha = @(x,y) 1;
f = @(x, y) 40*pi^2*sin(2*pi*x).*sin(4*pi*y);
% f = @(x,y) 32.*(x-x.^2+y-y.^2);

L2e = [];
for N = [2^2 2^3 2^4]
    S = N^2;
    h = 1/(N+1);
    A = zeros(S);
    for i = 1:S
        for j = [-N -1 0 1 N]
            if i+j>0 && i+j<=S
                xi = mod((i-1),N)*h+h;
                yi = floor((i-0.5)/N)*h+h;
                xj = mod((i+j-1),N)*h+h;
                yj = floor((i+j-0.5)/N)*h+h;
                A(i,i+j) = gauss2d(@(x,y) alpha(x,y)*(hatp(x,y,xi,yi,h,N)*hatp(x,y,xj,yj,h,N)'), min(xi,xj)-h, max(xi,xj)+h, min(yi,yj)-h, max(yi,yj)+h);
            end
        end
    end
%     for i = 1:S
%         A(i,i) = 4;
%         for j = [-N -1 1 N]
%             if (i+j>0) && (i+j<=S)
%                 A(i,i+j) = -1;
%             end
%         end
%     end
    b = zeros(S,1);
    for i = 1:S
        xi = mod((i-1),N)*h+h;
        yi = floor((i-1)/N)*h+h;
        b(i) = gauss2d(@(x,y) hat(x, y, xi, yi, h, N)*f(x,y), xi-h, xi+h, yi-h, yi+h);
        % b(i) = integral2(@(x,y) hat(x, y, xi, yi, h, N).*f(x,y), xi-h, xi+h, yi-h, yi+h);
    end
    A = sparse(A);
    phi = A\b;
%     u = ones(N+2);
    U = ones(N+2);
    for i = 1:N
        for j = 1:N
%             u(i+1,j+1) = 2*sin(2*pi*j*h)*sin(4*pi*i*h);
            U(i+1,j+1) = phi((i-1)*N+j);
        end
    end
    for i = 1:N
%          u(1, :) = 0;
%          u(N+2, :) = 0;
%          u(:, 1) = 0;
%          u(:, N+2) = 0;
        U(1, :) = 0;
        U(N+2, :) = 0;
        U(:, 1) = 0;
        U(:, N+2) = 0;
    end
    L2e = [L2e (integral2(@(X, Y)((interp2(U, X/h+1, Y/h+1)-2*sin(2*pi*X).*sin(4*pi*Y)).^2), 0, 1, 0, 1))^(1/2)];
end
figure();
hold on;
surf(U);
title('Solution')
xlabel('x')
ylabel('y')
zlabel('U')
disp(L2e)

%% Part 5 and 6
f = @(x, y) 5*pi^2*cos(pi*x)*sin(2*pi*y);

% N = 11;
N = 15;
M = N+2;
S = N*M;
h = 1/(N+1);
A = zeros(S);
for i = 1:S
    for j = [-M -1 0 1 M]
        if i+j>0 && i+j<=S
            xi = mod((i-1),M)*h;
            yi = floor((i-1)/M)*h+h;
            xj = mod((i+j-1),M)*h;
            yj = floor((i+j-1)/M)*h+h;
            A(i,i+j) = gauss2d(@(x,y) (hatp(x,y,xi,yi,h,N)*hatp(x,y,xj,yj,h,N)'), min(xi,xj)-h, max(xi,xj)+h, min(yi,yj)-h, max(yi,yj)+h);
        end
    end
end
for i = 1:M
    for j = [-1 0 1 M-1 M M+1]
        if i+j>0 && i+j<=S
            xi = mod((i-1),M)*h;
            yi = floor((i-1)/M)*h+h;
            xj = mod((i+j-1),M)*h;
            yj = floor((i+j-1)/M)*h+h;
            gauss2(@(x) hat(x,0,xi,yi,h,N)*(hatp(x,0,xj,yi,h,N)*[0;1]), min(xi,xj)-h, max(xi,xj)+h)
            A(i,i+j) = A(i, i+j) - gauss2(@(x) hat(x,0,xi,yi,h,N)*(hatp(x,0,xj,yi,h,N)*[0;1]), min(xi,xj)-h, max(xi,xj)+h);
        end
    end
end
for i = S-M+1:S
    for j = [-M-1 -M -M+1 -1 0 1]
        if i+j>0 && i+j<=S
            xi = mod((i-1),M)*h;
            yi = floor((i-1)/M)*h+h;
            xj = mod((i+j-1),M)*h;
            yj = floor((i+j-1)/M)*h+h;
            A(i,i+j) = A(i, i+j) - gauss2(@(x) hat(x,1,xi,yi,h,N)*(hatp(x,1,xj,yi,h,N)*[0;1]), min(xi,xj)-h, max(xi,xj)+h);
        end
    end
end
b = zeros(S,1);
for i = 1:S
    xi = mod((i-1),M)*h;
    yi = floor((i-1)/M)*h+h;
    b(i) = gauss2d(@(x,y) hat(x, y, xi, yi, h, N)*f(x,y), xi-h, xi+h, yi-h, yi+h);
end
A = sparse(A);
phi = A\b;
u = zeros(M);
U = zeros(M);
for i = 2:M-1
    for j = 1:M
        u(i,j) = cos(pi*(j-1)*h)*sin(2*pi*(i-1)*h);
        U(i,j) = phi((i-2)*M+j);
    end
end
figure();
hold on;
title('Solution')
xlabel('x')
ylabel('y')
zlabel('U')
surf(U);
figure();
hold on;
title('Error')
xlabel('x')
ylabel('y')
zlabel('Difference of analytical and numerical solution')
surf(abs(u-U));
e = (integral2(@(X, Y)((interp2(U, X/h+1, Y/h+1)-cos(pi*X).*sin(2*pi*Y)).^2), 0, 1, 0, 1))^(1/2)


%% debug
% hat
figure();
hold on;
for x = 0:h:1
    for y = 0:h:1
        plot3(x, y, hat(x,y,1/3,2/3,5*h,N), '*');
    end
end

%% debug 
% Load vector
figure();
hold on;
for N = [5 10 20 40]
    S = N^2;
    b = zeros(S,1);
    for i = 1:S
        xi = mod((i-1),N)*h+h;
        yi = floor((i-1)/N)*h+h;
        b(i) = gauss2d(@(x,y) hat(x, y, xi, yi, h, N)*f(x,y), xi-h, xi+h, yi-h, yi+h);
        % b(i) = integral2(@(x,y) hat(x, y, xi, yi, h, N).*f(x,y), xi-h, xi+h, yi-h, yi+h);
    end
end
