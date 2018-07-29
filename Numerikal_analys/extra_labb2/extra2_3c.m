load('dollar.mat');
format long;
k = size(kurs);
k = k(1);
A = [(zeros(k,1)+1), (1:k)', sin(2*pi/100*(1:k))', cos(2*pi/100*(1:k))'];
c = A\kurs;
c
