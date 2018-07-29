%% Initialization
d1 = 24;
d2 = 24;
n=8;
dummystep=31*d1+d2;
rng('default');
for i=1:dummystep
    dummy=rand;
end
Corr=zeros(n,n);
for i=1:n
    for j=1:n
        Corr(i,j)=(-1)^abs(i-j)/(abs(i-j)+1);
    end
end
sigma=zeros(n,1);
mu=zeros(n,1);
sigma(1)=2;
mu(1)=3;
for i=1:n-1
    sigma(i+1)=sigma(i)+2*rand;
    mu(i+1)=mu(i)+1;
end
D=diag(sigma);
C2=D*Corr*D;
C=0.5*(C2+C2');


%% 1
figure()
hold on;
sigma1 = zeros(25, 1);
mux1 = zeros(25,1);
rv = 3.00:0.25:9.00;
for i = 1:25
    r = rv(i);
    x = quadprog(2*C, zeros(n,1), zeros(n,n), zeros(n,1), [mu ones(n,1)]', [r 1]', zeros(n,1), ones(n,1)*inf);
    sigma1(i) = sqrt(x'*C*x);
    mux1(i) = mu'*x;
    text(sigma1(i)+0.03, mux1(i), strcat('r=',num2str(r)));
end

plot(sigma1, mux1, 'r*-');
title('Plot for situation 1')
xlabel('Risk parameter sigma')
ylabel('Expected value of the rate of return mu')

%% 2
figure()
hold on;
sigma2 = zeros(25, 1);
mux2 = zeros(25,1);
rv = 3.00:0.25:9.00;
for i = 1:25
    r = rv(i);
    x = quadprog(2*C, zeros(n,1), ones(n,1)', 1, [mu]', [r]', zeros(n,1), ones(n,1)*inf);
    sigma2(i) = sqrt(x'*C*x);
    mux2(i) = mu'*x;
    text(sigma2(i)+0.013, mux2(i), strcat('b=',num2str(r)));
end

plot(sigma1, mux1, 'r*-');
plot(sigma2, mux2, 'bo-')
title('Plot for situation 2')
xlabel('Risk parameter sigma')
ylabel('Expected value of the rate of return mu')

%% 3
figure()
hold on;
sigma3 = zeros(25, 1);
mux3 = zeros(25,1);
rv = 3.00:0.25:9.00;
for i = 1:25
    r = rv(i);
    x = quadprog(2*C, zeros(n,1), -mu', -r, [ones(n,1)]', [1]', zeros(n,1), ones(n,1)*inf);
    sigma3(i) = sqrt(x'*C*x);
    mux3(i) = mu'*x;
    text(sigma3(i)+0.013, mux3(i), strcat('b=',num2str(r)));
end

plot(sigma1, mux1, 'r*-');
plot(sigma3, mux3, 'bo-')
title('Plot for situation 3')
xlabel('Risk parameter sigma')
ylabel('Expected value of the rate of return mu')


%% 4
figure()
hold on;
sigma4 = zeros(25, 1);
mux4 = zeros(25,1);
rv = 3.00:0.25:9.00;
for i = 1:25
    r = rv(i);
    x = quadprog(2*C, zeros(n,1), zeros(n,n), zeros(n,1), [mu ones(n,1)]', [r 1]');
    sigma4(i) = sqrt(x'*C*x);
    mux4(i) = mu'*x;
    text(sigma4(i)+0.013, mux4(i), strcat('b=',num2str(r)));
end

plot(sigma1, mux1, 'r*-');
plot(sigma4, mux4, 'bo-')
title('Plot for situation 4')
xlabel('Risk parameter sigma')
ylabel('Expected value of the rate of return mu')