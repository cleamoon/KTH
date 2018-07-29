% Resultat
% err =
% 
%   20.834970916660637
% 
% 
% err =
% 
%    0.403162939933826
% 
% 
% err =
% 
%    0.847265509898796
% 
% 
% err =
% 
%    0.048532589859940
% 
% 
% err =
% 
%    0.040026085059015
% 
% 
% err =
% 
%    0.003656388386481
% 
% 
% err =
% 
%    0.001982136731479
% 
% 
% err =
% 
%      2.395154335948587e-04
% 
% 
% err =
% 
%      1.003227296550304e-04
% 
% 
% err =
% 
%      1.464764468101570e-05
% 
% 
% err =
% 
%      5.167222064625530e-06
% 
% 
% err =
% 
%      8.615518783882698e-07
% 
% 
% err =
% 
%      2.699316261259749e-07
% 
% 
% d1 =
% 
%    7.926327089601748
% 
% 
% d2 =
% 
%   -0.001540910309235
% 
% 
% d3 =
% 
%    0.357029687510287
% 
% 
% d4 =
% 
%    0.318620164473722
% 
% 
% L =
% 
%      4.778200426489563e+02
% 
% 
% Medelkvadratfel =
% 
%    0.059238912651613
% 
% Daglig ändring =
% 
%    0.004393569490676

load ('dollar.mat');
clc;
f = @(d1,d2,d3,d4,t,L)  d1 + d2*t + d3*sin(2*pi*t/L) + d4*cos(2*pi*t/L);
J = @(d1,d2,d3,d4,t,L) [ ones(size(t)), t, sin((2*pi*t)/L), cos((2*pi*t)/L), (2*pi*d4*t.*sin((2*pi*t)/L))/L^2 - (2*pi*d3*t.*cos((2*pi*t)/L))/L^2];
le = size(kurs);
tol = 0.5*10^-6;
q = @(d1,d2,d3,d4,L, jr) (jr'*jr)\(jr'*(kurs-f(d1,d2,d3,d4,[1:le]',L)));

d1 = 8; d2 = -0.002; d3 = 0.3; d4 = 0.4; L = 500;
err=Inf;
tmpv = [d1 d2 d3 d4 L]';
while err > tol
    jr = J(d1,d2,d3,d4,[1:le]',L);
    v = q (d1,d2,d3,d4,L,jr);
    err = norm(v, Inf)
    tmpv = tmpv + v;
    d1 = d1 + v(1);
    d2 = d2 + v(2);
    d3 = d3 + v(3);
    d4 = d4 + v(4);
    L = L + v(5);
end

d1
d2
d3
d4
L
plot([1:le]', f(d1, d2, d3, d4, [1:le]', L))
hold on
plot([1:le]', kurs)
for i = 1:le
  a = kurs(i);
  b = f(d1, d2, d3, d4, i, L);
  plot([i i], [a b]);
  hold on;
end
ems = 0;
for i = 1:le
  ems = ems + (kurs(i) - f(d1, d2, d3, d4, i, L))^2;
end
ems / le(1)
k = le(1)-1;
change = zeros(k,1);
for i = 1:k
  a = f(d1, d2, d3, d4, i, L);
  b = f(d1, d2, d3, d4, i+1, L);
  change(i) = abs(a-b);
end
sum(change)/(k)