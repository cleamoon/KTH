% Resultat på min dator
% I1 =
% 
%    0.154664778031637
% 
% 
% I2 =
% 
%    0.154664782669482
% 
% 
% diff =
% 
%      4.637844719379558e-09
% 
% 
% ref =
% 
%    0.154664784123405
% 
% Trappets
%   Kvot                 Konvergens
%   -3.737834934983356   1.902202860217628
%    3.707281290481064   1.890361583996023
%    3.906772121059423   1.965977106710360
%    3.963213687763550   1.986670756345908
%    3.983964325475422   1.994204728809074
%    3.992569833099801   1.997317641696793
%    3.996432315356358   1.998712655574042
%    3.998253125384517   1.999369810546034

xh = 1.5;
yh = 0;
zh = 0.25;
d = 10;
f = @(x,y) exp(-d*((x-xh).^2+(y-yh).^2));

n = 12;
h = 2.^-(1:n);

a = 0;
b = 2;

tol = 10^-3;

format long

I1 = integrateTriagle(f, a, b, tol/2)
I2 = integrateTriagle(f, a, b, tol/4)

diff = abs(I1-I2)


ref = integrateTriagle(f, a, b, 2^-14)

t = zeros(size(h));
s = zeros(size(h));
IT = zeros(size(h));

for i = 1:n
    IT(i) = integrateTriagle(f, a, b, h(i));
    t(i) = abs(IT(i) - ref);
end

loglog(h, t)
hold on;
loglog(h, h.^2, 'k')
setGrid()

kT = zeros(n-4, 2);
kS = zeros(n-4, 2);

for i = 1:n-4
    kT(i, 1) = (IT(i)-IT(i+1))/(IT(i+1)-IT(i+2));
    kT(i, 2) = log2(abs(kT(i, 1)));
end

fprintf('Trappets\n  Kvot                 Konvergens\n')
disp(kT)

format
