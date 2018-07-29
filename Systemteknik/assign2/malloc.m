%% data
lambda = [55, 43, 36, 70, 29, 45, 111]'/1000;
c = [5, 18, 14, 17, 16, 24, 70]';
T = [8, 4, 14, 3, 14, 9, 25]';
C_max = 500;
s_max = ceil(C_max/(min(c)));
N = size(c)*[1; 0];


%% Problem 1
p = zeros(N, s_max);
for j = 1:1:N
    for k = 0:1:s_max
        p(j, k+1) = (((lambda(j)*T(j))^k)/(factorial(k)))*exp((-lambda(j)*T(j)));
    end
end
R = zeros(N, s_max);
for sj = 0:1:s_max
    for j = 1:1:N
        R(j, sj+1) = 1;
        for i = 0:1:sj
            R(j, sj+1) = R(j, sj+1)- p(j, i+1);
        end
    end
end
M = zeros(N, s_max);
for sj = 0:1:s_max
    for j = 1:1:N
        M(j, sj+1) = R(j, sj+1)/c(j);
    end
end
M = M';

s = [zeros(1,N)];
C = [0];
pi = 0;
for i=1:1:N
    pi = pi + lambda(i)*T(i);
end
EBO = [pi];
k = 1;
while 1==1
    mk = zeros(1,N);
    for j = 1:1:N
        mk(1, j) = M(s(k,j)+1, j);
    end
    [~, l] = max(mk);
    sl = s(k,:);
    k = k+1;
    s(k, :) = sl;
    s(k, l) = s(k, l)+1;
    C(k) = C(k-1) + c(l);
    EBO(k) = EBO(k-1) - R(l, s(k-1, l)+1);
    if C(k) >= C_max
        break
    end
end

%% Problem 2
EBOi = zeros(N,1);
for i=1:1:N
    EBOi(i, 1) = lambda(i)*T(i);
end
for i=1:1:s_max+1
    EBOi = [EBOi EBOi(:, i)-R(:, i)];
end

f = zeros(N+1,C_max+1);
for k = N:-1:1
    for s=0:1:C_max
        sup = floor(s/c(k));
        list = zeros(1,sup+1);
        for xi = 0:1:sup
            list(xi+1) = EBOi(k, xi+1)+f(k+1, s-xi*c(k)+1);
        end
        f(k, s+1) = min(list);
    end
end



%% Plots
hold on;
xlabel('Budget');
ylabel('EBO');
title('EBO / budget graph');
plot(C(:), EBO(:),'*-b');
plot([0:1:C_max], f(1,:), '.r');
plot(C_max*[1,1], [floor(min(EBO(:))) ceil(max(EBO(:)))], 'm-');
