%% Initialization
clc, close all

%% Problem C,1,1,1
figure()
hold on;
pos = 1;
u0 = [0 0]'; 
t0 = 0;
h = 0.01; 
N = 1000;
E = 10;
L = 0.1;
C = 0.1;
g = [0 E/L]';

for R=[0.01 0.1 1 10]
    %Defining matrix
    A = [0 1; -1/L/C -R/L];
    result = zeros(N, 2);
    result(1, :) = u0;
    time = zeros(N, 1);
    time(1) = t0;
    for k = 1:N
       t = k*h;
       tmp = expm(A*t);
       u = tmp*u0 + A\((tmp-eye(2))*g);
       result(k+1, :) = u;
       time(k+1) = t;
    end
    subplot(2, 2, pos)
    plot(time, result(:, 1))
    pos = pos + 1;
    %legend('y', 'dy/dt', 'd^2 y/dt^2');
    title(strcat('Solutions to the ODE for R = ', num2str(R)));
    xlabel('t');
    ylabel('y');
end 

%% Problem C1,1,2
figure()
hold on;
pos=1;
u0 =[1 1 1]'; 
t0 = 0;
h = 0.1; 
N = 300;

for K=[0 1 4 8]
    %Defining matrix
    A = [0 1 0; 0 0 1; -K -2 -3];
    result = zeros(N, 3);
    result(1, :) = u0;
    time = zeros(N, 1);
    time(1) = t0;
    for k = 1:N
       t = k*h;
       u = expm(A*t) * u0;
       result(k+1, :) = u;
       time(k+1) = t;
    end
    subplot(2, 2, pos)
    plot(time, result(:, 1))
    pos = pos + 1;
    %legend('y', 'dy/dt', 'd^2 y/dt^2');
    title(strcat('Solutions to the ODE for K = ', num2str(K)));
    xlabel('t');
    ylabel('y');
end 

%% Root locus of A
figure
grid on
count=1;
for K=0:0.01:10
    A=[0 1 0; 0 0 1 ;-K -2 -3]';
    eigenvalue=eig(A);
    t=length(eigenvalue);
    hold on
    plot(real(eigenvalue(1)),imag(eigenvalue(1)),'go',real(eigenvalue(2)),imag(eigenvalue(2)),'yo',real(eigenvalue(3)),imag(eigenvalue(3)),'ro')
    real_part=real(eigenvalue);
    
    %Finding K where system becomes unstable
    for i=1:3
        if real_part(i) > 0
            K_unstable(count) = K;
            count=count+1;
        end
    end
    %unstable k
    
    %Finding K where system becomes unstable
end
legend('Eigenvalue 1','Eigenvalue 2','Eigenvalue 3')
ylabel('Im')
xlabel('Re')
title('Root locus of the matrix A where K is varied')

Unstable_K=K_unstable(1)

%% Problem C.1.1.2.2
result = [];
eigs = [];
guesses = [8 -5 2; -8 5 2; 9 3 7; -9 -3 7]';
eps = 0.001;
for u = guesses
    while true
        J = [5-u(3)  4  -u(1); 1 4-u(3) -u(2); 2*u(1) 2*u(2) 0];
        f = [5*u(1)+4*u(2)-u(1)*u(3); u(1)+4*u(2)-u(2)*u(3); u(1)*u(1)+u(2)*u(2)-89];
        du = J\f;
        if max(du) < eps
            result = [result; u'];
            eigs = [eigs; eig(J)'];
            break;
        end
        u = u - du;
    end
end
result
eigs