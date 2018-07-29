% Resultat på min dator. 
% I1 =
% 
%    0.124986333840348
% 
% 
% I2 =
% 
%    0.124985908663649
% 
% 
% diff =
% 
%      4.251766995422290e-07
% 
% Trappets
%   Kvot                 Konvergens
%   15.132589595937516   3.919586987764786
%    3.860352934374085   1.948732752517889
%    3.952154321659689   1.982639281625610
%    3.992741602505765   1.997379708373139

zh = 0.25;
d = @(z) 50*(z + zh)*exp(-z/(2*zh));

xh = 1.5;
yh = 0;
zh = 0.25;
f = @(x,y,z) exp(-d(z)*((x-xh).^2+(y-yh).^2));

tol = 5*10^-3;

n = 8;
h = 2.^-(1:n);

a = [0 0 0];
b = [2 1 1];

format long

I1 = integratePrism1D(f, a, b, tol)
I2 = integratePrism1D(f, a, b, tol/2)

diff = abs(I1-I2)

ref = I2;

t = zeros(size(h));
s = zeros(size(h));
IT = zeros(size(h));

for i = 1:n
    IT(i) = integratePrism1D(f, a, b, h(i));
    t(i) = abs(IT(i) - ref);
end

loglog(h, t)
hold on;
loglog(h, h.^2, 'k')
setGrid();


kT = zeros(n-4, 2);
kS = zeros(n-4, 2);

for i = 1:n-4
    kT(i, 1) = (IT(i)-IT(i+1))/(IT(i+1)-IT(i+2));
    kT(i, 2) = log2(abs(kT(i, 1)));
end

fprintf('Trappets\n  Kvot                 Konvergens\n')
disp(kT)

format


