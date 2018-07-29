%% First part
%% a
clear, clc;
n = 8;
[A, b] = illposed(n);
x = A\b;
c = 100;
for s = [10^-12 10^-13 10^-14 10^-15]
  k = zeros(1, c);
  for i = 1:c
    deltab = rand(n,1)*s;
    xnew = A\(b+deltab);
    k(i) = (norm(xnew-x)/norm(x))/(norm(deltab)/norm(b));
  end
  fprintf('The mean condition number when the deltab is around %e is %e.\n', s, mean(k))
end
fprintf('The condition number calculated by COND is: %e.\n', cond(A))

%% b
[A, b] = illposed(8);
format long
for r = [8 7 6 5]
  [Q, R, P] = qr(A);
  R11 = R(1:r, 1:r);
  E = R(r+1:8, r+1:8);
  fprintf('When rank is %d\n', r);
  fprintf('\t norm(E): %e\n', norm(E))
  fprintf('\t cond(R11): %e\n', cond(R11))
  np = 20;
  cp = 100;
  ck = zeros(np, 1);
  for i = 1:np
    xp = rand(r,1);
    bp = R11*xp;
    kp = zeros(1, cp);
    for j = 1:cp
      deltabp = rand(r,1).*10^-15;
      xnewp = R11\(bp+deltabp);
      kp(j) = (norm(xnewp-xp)/norm(xp))/(norm(deltabp)/norm(bp));
    end
    ck(i) = mean(kp);
  end
  fprintf('\t Experimental condition number of R11: %e\n', mean(ck))
  fprintf('\t norm(x): %e\n', norm(A\b))
  D = Q'*b;
  dt = D(1:r);
  yt = R11\dt;
  xt = P*([yt; zeros(8-r, 1)]);
  res = A*xt - b;
  fprintf('\t norm(res): %e\n', norm(res))
end

%% Second part
load('manualoa8000.dat')
%pick out the monthly values (column 2:13) and store columnwise in Q
Q=manualoa8000(:,2:13)';
b=Q(:); %all measurements are in time increasing order in one column
m=length(b);
t=[1:m]';
%plot(t,b,'x');
tend = m;
range = ones(m,1);
alpha = 0.00037;
tic
for k = 1:3
    A = [range, exp(alpha*t)];
    for i = 1:k
        A = [A, cos(2*pi*i*t/12), sin(2*pi*i*t/12)];
    end
    [Q, R, P] = qr(A);
    d = Q'*b;
    y = R\d;
    x = P*y;
    bfit = A*x;
    res = abs(bfit-b);
%     x = A\b;
%     bfit2 = x(1)*range + x(2)*exp(alpha*t);
%     for i = 1:k
%         bfit2 = bfit2 + x(3+(i-1)*2)*cos(2*pi*i*t/12) + x(4+(i-1)*2)* sin(2*pi*i*t/12);
%     end
    figure();
    hold on;
    plot(t, b, 'bo-');
    plot(t, bfit, 'r*-');
    title(strcat('Data fitting when k = ', num2str(k)));
    xlabel('Time (month)');
    ylabel('CO2 concentration');
    % plot(t, bfit2, 'g.-');
    fprintf('The 2-norm residual when k=%d is: %f\n', k, norm(res));
end
toc
