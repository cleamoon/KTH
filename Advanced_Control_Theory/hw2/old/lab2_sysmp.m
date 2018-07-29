clear all;

%% task 3.1.1
sysmp = minphase;
G = tf(sysmp);

G11_poles = pole(G(1,1))
G12_poles = pole(G(1,2))
G21_poles = pole(G(2,1))
G22_poles = pole(G(2,2))

G11_zeros = tzero(G(1,1))
G12_zeros = tzero(G(1,2))
G21_zeros = tzero(G(2,1))
G22_zeros = tzero(G(2,2))

%% task 3.1.2

G_poles = pole(G)
G_zeros = tzero(G)

% yes, all neg.

%% task 3.1.3

sigmaMax = max(sigma(sysmp));
sigmaMin = min(sigma(sysmp));
Hinf = hinfnorm(sysmp)

%% task 3.1.4

[num,den] = tfdata(G);
row = [1,1,2,2];
col = [1,2,1,2];
G0 = zeros(2,2);
for n=1:4
    G0(row(n),col(n)) = num{n}(end)/den{n}(end);
end
RGA = G0.*inv(G0)'


%% task 3.1.5
% close all
% for m=1:2
%     for n=1:2
%         figure()
%         GC = G(m,n)/(1+G(m,n));
%         stepinfo(GC)
%         grid on
%     end
% end

%% task 3.2.1
s = tf('s');
% y1 --> u1
% y2 --> u2
wc = 0.1;
phase = pi/3;

for n=1:2
    [m,argG] = bode(G(n,n),wc);
    T(n) = (tan(pi/2 + phase - pi - deg2rad(argG)))/wc;
    l(n) = G(n,n)*(1+1/(s*T(n)));
    K(n) = 1/bode(l(n),wc);
    f(n) = K(n)*(1+1/(s*T(n)));
end

F = [f(1) 0; 0 f(2)];

L = G*F;

figure()
margin(L(1,1))
grid on;
figure()
margin(L(2,2))
grid on;

%% task 3.2.2

S = (1+L)^-1;
T = S*L;
