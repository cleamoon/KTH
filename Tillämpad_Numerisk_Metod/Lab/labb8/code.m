n = 36;
h = 6/(n-1);
nk = 60;
hk = 6/(nk-1);
y = 0:h:6;
x = 0:hk:6;
p = 0.8*cos(pi*x/6) - 0.4*cos(pi*x/2) + 1;
beta = 1.5;
K = zeros(n, nk);
for i = 1:n
    for j = 1:nk
        yp = y(i);
        xp = x(j);
        if abs(yp-xp) < beta
            K(i,j) = 1/2/beta*(1 + cos(pi*(yp - xp)/beta));
        end
    end
end
A = zeros(n, nk);
for i = 1:n
    for j = 1:nk
        A(i,j) = hk*K(i,j);
        if j == 1 || j == nk
            A(i, j) = A(i, j)/2;
        end
    end
end
[U,S,V] = svd(A);
f = A*p';
f = f' + 0.01*randn(1,length(f));
figure()
hold on;
plot(x, A\f', '--')
plot(x, p, '*-')
title('Solved with Gauss elimination')
xlabel('x')
ylabel('y')
legend('A\f', 'real p')
figure()
hold on;
title('Solved with truncated SVD-factorization')
xlabel('x')
ylabel('y')
plot(x, p, '*-', 'DisplayName', 'real p');
d = U'*f';
for r = 1:n
    z = zeros(1,60);
    for i = 1:r
        z(i) = d(i)/S(i,i);
    end
    pc = V*z';
    error = norm(p'-pc);
    fprintf('When the rank of the truncated matrix is %d, the error is %f \n', r, error);
    if error < 1
        plot(x, pc ,'DisplayName', num2str(r));
    end
end
legend('show')