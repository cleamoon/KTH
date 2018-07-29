% Resultat
% c =
% 
%    8.058590415468743
%   -0.001717874569616

load('dollar.mat');
format long;
k = size(kurs);
k = k(1);
A = [(zeros(k,1)+1), (1:k)'];
c = A\kurs;
c

x = 1:k;
hold on
plot(x, kurs)
plot(x, c(1)+c(2).*x)
