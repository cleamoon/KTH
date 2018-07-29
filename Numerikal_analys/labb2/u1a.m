load ('eiffel1.mat');

clf;

trussplot(xnod,ynod,bars);
hold on;
m = size(xnod);
N = m(1);
% j = randi (N);
j = 200;
b=zeros(2*N,1);
b(j*2-1)=1;
x = A\b;
xbel = xnod + x(1:2:end); ybel = ynod + x(2:2:end);
trussplot(xbel,ybel,bars);
hold on;
drawCircle(xbel(j,1), ybel(j,1), 0.1);