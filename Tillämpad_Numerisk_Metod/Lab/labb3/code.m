%% Initialization
clear, clc

%% Different stepsize when nu = 0
L = 10; 
a = 1; 
b = 3;
Q0 = 50;
kappa = 0.5;
k = 10;
rho = 1;
C = 1;
Tout = 300;
T0 = 400;
nu = 0;
figure();
hold on;
for N = [10 20 40 80]
    h = L/N;
    N = N+1;
    A = zeros(N);
    bvec = zeros(N,1);
    for i=2:N-1
        A(i,i-1) = -nu*rho*C/2/h-kappa/h^2;
        A(i,i) = 2*kappa/h^2;
        A(i,i+1) = nu*rho*C/2/h-kappa/h^2;
        bvec(i) = Qfunc(i*h, a, b, Q0);
    end
    A(1, 1) = 1;
    A(N, N-2) = -1;
    A(N, N-1) = 2*h*k/kappa;
    A(N, N) = 1;
    bvec(N) = 2*h*k*Tout/kappa;
    bvec(1) = T0;
    T = sparse(A)\bvec;
    plot([0 h*(1:N-1)], [T])
    axis([0, L, 150 450]);
end
title('Solution when \nu = 0')
xlabel('z')
ylabel('T')
legend('N = 10', 'N = 20', 'N = 40','N = 80', 'Location', 'North')

%% Different nu when N = 40
L = 10; 
a = 1; 
b = 3;
Q0 = 50;
kappa = 0.5;
k = 10;
rho = 1;
C = 1;
Tout = 300;
T0 = 400;
N = 40;
figure();
hold on;
for nu = [0 0.1 0.5 1 10]
    h = L/N;
    N = N+1;
    A = zeros(N);
    bvec = zeros(N,1);
    for i=2:N-1
        A(i,i-1) = -nu*rho*C/2/h-kappa/h^2;
        A(i,i) = 2*kappa/h^2;
        A(i,i+1) = nu*rho*C/2/h-kappa/h^2;
        bvec(i) = Qfunc(i*h, a, b, Q0);
    end
    A(1, 1) = 1;
    A(N, N-2) = -1;
    A(N, N-1) = 2*h*k/kappa;
    A(N, N) = 1;
    bvec(N) = 2*h*k*Tout/kappa;
    bvec(1) = T0;
    T = sparse(A)\bvec;
    plot([0 h*(1:N-1)], [T])
    axis([0, L, 150 450]);
end
title('Solution when N = 40 with different \nu')
xlabel('z')
ylabel('T')
legend('\nu = 0', '\nu = 0.1', '\nu = 0.5','\nu = 1', '\nu = 10', 'Location', 'Southeast')

%% Fix spurious
L = 10; 
a = 1; 
b = 3;
Q0 = 50;
kappa = 0.5;
k = 10;
rho = 1;
C = 1;
Tout = 300;
T0 = 400;
nu = 10;
figure();
hold on;
for N = [10 20 40 80]
    h = L/N;
    N = N+1;
    A = zeros(N);
    bvec = zeros(N,1);
    for i=2:N-1
        A(i,i-1) = -kappa/h^2-nu*rho*C/h;
        A(i,i) = 2*kappa/h^2+nu*rho*C/h;
        A(i,i+1) = -kappa/h^2;
        bvec(i) = Qfunc(i*h, a, b, Q0);
    end
    A(1, 1) = 1;
    A(N, N-2) = -1;
    A(N, N-1) = 2*h*k/kappa;
    A(N, N) = 1;
    bvec(N) = 2*h*k*Tout/kappa;
    bvec(1) = T0;
    T = sparse(A)\bvec;
    plot([0 h*(1:N-1)], [T])
    axis([0, L, 350 450]);
end
title('Solution when \nu = 10')
xlabel('z')
ylabel('T')
legend('N = 10', 'N = 20', 'N = 40','N = 80', 'Location', 'North')
