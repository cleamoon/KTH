% Resultat
% Medelkvadratfel är :
%    0.167928510466555

load('dollar.mat');
k = 730;
y = @(x) 8.05859041546872668 - 0.00171787456961633*x;
plot([0 k+1], [y(0) y(k+1)]);
hold on;
for i = 1:k
  a = kurs(i);
  b = y(i);
  plot([i i], [a b]);
  hold on;
end
ems = 0;
for i = 1:k
  ems = ems + (kurs(i) - y(i))^2;
end
ems / k
