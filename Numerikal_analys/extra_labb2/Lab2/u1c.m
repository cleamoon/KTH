load ('eiffel1.mat');

trussplot(xnod, ynod, bars);
hold on;
max_bel = -Inf;
min_bel = Inf;
max_j = 1;
min_j = 1;

m = size(xnod);
N = m(1);
for j = 1 : N
    clearvars b x xbel ybel;
    b=zeros(2*N,1);
    b(j*2)=-1;
    x = A\b;
    abs_bel = norm(x);
    if abs_bel > max_bel
        max_bel = abs_bel;
        max_j = j;
    end
    if abs_bel < min_bel
        min_bel = abs_bel;
        min_j = j;
    end
end

clearvars b x xbel ybel;

b = zeros(2*N,1);
b(max_j*2)=-1;
x = A\b;
xbel = xnod + x(1:2:end); ybel = ynod + x(2:2:end);
trussplot(xbel, ybel, bars);
hold on;
drawCircle(xbel(max_j,1), ybel(max_j,1), 0.1);

figure

clearvars b x xbel ybel;

b = zeros(2*N,1);
b(min_j*2)=-1;
x = A\b;
xbel = xnod + x(1:2:end); ybel = ynod + x(2:2:end);
trussplot(xbel, ybel, bars);
hold on;
xbel(min_j,1)
drawCircle(xbel(min_j,1), ybel(min_j,1), 0.1, 'k');