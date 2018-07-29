%% Initialization
clear, clc;

%% C.2.1.1
Ns = [10 20 40 80 160 320];
u_end = [];
f = @(u) [0, 1; -1, 1-u(1)^2]*u;
for N = Ns
    h = 1/N;
    u = [1 0]';
    for t = h:h:1
        k1 = f(u);
        k2 = f(u + h*k1);
        k3 = f(u + h*k1/4 + h*k2/4);
        u = u + h/6 * (k1 + k2 + 4*k3);
    end
    u_end = [u_end; u(1)];
end
figure();
loglog(Ns, abs(u_end-u_end(end)));
title('Error against stepsize');
xlabel('Stepsize');
ylabel('Error');
xlim([0 320]);
hold on;
grid on;

%% C.2.1.2.1
Ns = [125 250 500 1000 2000];
u_end = [];
Np = [];
c1 = 0.04;
c2 = 10^4;
c3 = 3*10^7;
f = @(u) [-c1*u(1)+c2*u(2)*u(3); c1*u(1)-c2*u(2)*u(3)-c3*u(2)^2; c3*u(2)^2];
solved = false;
for N = Ns
    h = 1/N;
    u = [1 0 0]';
    sol = zeros(N, 3);
    for t = 1:N
        k1 = f(u);
        k2 = f(u + h*k1);
        k3 = f(u + h*k1/4 + h*k2/4);
        u = u + h/6 * (k1 + k2 + 4*k3);
        sol(t, :) = u;
    end
    if and(not(isnan(u(1))), not(solved))
        solved = true;
        smallest_sol = sol;
    end
end
figure();
disp(size(smallest_sol)*[1 0]');
loglog(smallest_sol, '.--');
title('Numerical solution to Robertsons problem')
xlabel('t')
ylabel('x')
hold on;
grid on;

%% C.2.1.2.2
c1 = 0.04;
c2 = 10^4;
c3 = 3*10^7;
g = @(t, u) [-c1*u(1)+c2*u(2)*u(3);c1*u(1)-c2*u(2)*u(3)-c3*u(2)^2;c3*u(2)^2];
Ns = [];
Nss = [];
Tol = 10.^(-[3, 4, 5, 6]);
for rt = Tol
    [t, y] = ode23(g, [0 1], [1 0 0], odeset('RelTol', rt));
    [ts, ys] = ode23s(g, [0 1000], [1 0 0], odeset('RelTol', rt));
    Ns = [Ns; size(t)*[1 0]'];
    Nss = [Nss; size(ts)*[1 0]'];
end
figure();
hold on;
loglog(t(1:Ns(end)-1), abs(t(2:Ns(end))-t(1:Ns(end)-1)));
title('Stepsize as function of t for the solution with ode23')
xlabel('t')
ylabel('Stepsize h')
grid on;
figure();
hold on;
loglog(ts(1:Nss(end)-1), abs(ts(2:Nss(end))-ts(1:Nss(end)-1)));
title('Stepsize as function of t for the solution with ode23s')
xlabel('t')
ylabel('Stepsize h')
grid on;

%% C.2.1.3.1
N = 1000;
R = 2;
f = @(u) [1-R^2*(u(1)^2-u(2)^2)/(u(1)^2+u(2)^2)^2; -2*u(1)*u(2)*R^2/(u(1)^2+u(2)^2)^2]';
% nn = 101;
% pos = zeros(2, nn);
% pos(1, :) = -4;
% b = 1.6;
% e = 1.6;
% pos(2, :) = b:(e-b)/(nn-1):e;
% pos = pos';
pos = [-4 0.2; -4 0.6; -4 1.0; -4 1.6];
figure();
hold on;
axis equal;
for i = 1:size(pos)*[1 0]'
    u = pos(i, :);
    h = 10/N;
    sol = zeros(N, 2);
    for t = 1:N
        k1 = f(u);
        k2 = f(u + h*k1);
        k3 = f(u + h*k1/4 + h*k2/4);
        u = u + h/6 * (k1 + k2 + 4*k3);
        sol(t, :) = u;
    end
    plot(sol(:, 1), sol(:, 2), '.');
end
plot(2*cos(0:pi/100:2*pi), 2*sin(0:pi/100:2*pi));
title('Particle flow past a cylinder')
xlabel('x')
ylabel('y')


%% C2.1.3.2
clc,clear all,close all
N=1000;
i=1;
for k=[0.02 0.065]
    subplot(2,1,i)
    for a=[30 45 60]
    count=1;
    h = 1/N;
    u = [0 20*cosd(a) 1.5 20*sind(a)]';
    f = @(u) [u(2); -k*u(2)*sqrt((u(2)^2+u(4)^2)); u(4); -9.81-k*abs(u(4))*sqrt((u(2)^2)+(u(4)^2))];
   t=1;
    while 1==1
        if u(3) <= 0
            break;
        end
        k1 = f(u);
        k2 = f(u + h*k1);
        k3 = f(u + h*k1/4 + h*k2/4);
        u = u + h/6 * (k1 + k2 + 4*k3);
        sol(t,:)=u;
        t=t+1;
    end
    axis equal
    hold on
    grid on
    plot(sol(1:t-1,1),sol(1:t-1,3))
    end
    legend('a=30','a=45','a=60')
    grid on
    xlabel('x-axis')
    ylabel('y-axis')
    title(['Solution trajectory k=', num2str(k)])
    i=i+1;
end