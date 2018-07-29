% Resultat
% Medelkvadratfel är :
%    0.060209360117923
% 
% Daglig ändring =
% 
%    0.004245650869353

load('dollar.mat');
format long;
k = size(kurs);
k = k(1);
l = 500;
A = [(zeros(k,1)+1), (1:k)', sin(2*pi/l*(1:k))', cos(2*pi/l*(1:k))'];
c = A\kurs;
c

x = 1:k;
hold on
plot(x, kurs)
y = c(1)+c(2).*x+c(3)*sin(2*pi*x/l)+c(4)*cos(2*pi*x/l);
plot(x, y);
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
k = le(1)-1;
change = zeros(k,1);
for i = 1:k
  a = y(i);
  b = y(i+1);
  change(i) = abs(a-b);
end
sum(change)/(k)