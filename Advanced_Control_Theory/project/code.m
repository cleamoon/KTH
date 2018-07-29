%% Change setting between minimum and nonminimum
clear;
clc;
nonminphase; % Change this

s = tf('s');
A = ans.A;
B = ans.B;
C = ans.C;
D = ans.D;

wc = 0.02; % Change this
pm = 60;

G = C * inv(s*eye(4)-A) * B + D;
W2 = eye(2);
RGA0 = evalfr(G, 0).*(inv(evalfr(G, 0)))'
RGAc = abs(evalfr(G, 1i*wc).*(inv(evalfr(G, 1i*wc)))')

% W1 = minreal([1, -G(2,1)/G(2,2); -G(1,2)/G(1,1), 1]) % Minimum phase
W1 = minreal([-G(2,2)/G(2,1), 1; 1, -G(1,1)/G(1,2)]); % Non-minimum phase
W1 = W1*(10*wc)/(s+10*wc) % Non minimum phase 
Gtilda = minreal(G*W1);

figure()
bode(Gtilda)
grid on

[~, phase1] = bode(Gtilda(1,1), wc);
[~, phase2] = bode(Gtilda(2,2), wc);
T1 = 1/wc * tand(pm - 90 - phase1);
T2 = 1/wc * tand(pm - 90 - phase2);
l1 = Gtilda(1,1) * (1 + 1/(T1*s));
l2 = Gtilda(2,2) * (1 + 1/(T2*s));
[K1i, ~] = bode(l1, wc);
[K2i, ~] = bode(l2, wc);
K1 = 1 / K1i;
K2 = 1 / K2i;
Ftilda1 = K1 * (1 + 1/(T1*s));
Ftilda2 = K2 * (1 + 1/(T2*s));
Ftilda = [Ftilda1, 0; 0, Ftilda2];

F = W1 * Ftilda;
L = minreal(G * F);

figure()
bode(L)
grid on

%% Run simulink before continue
%%
figure()
plot(yout.Time, yout.Data)
title('Simulink result of dynamic decoupling')
xlabel('Time')
ylabel('y')
grid on


%% Update F
[Fr, gam] = rloop(L, 1.1);
F = F*Fr;

%% Run simulink before continue
%%
figure()
plot(yout.Time, yout.Data)
title('Simulink result of Glover-MacFarlane')
xlabel('Time')
ylabel('y')
grid on
