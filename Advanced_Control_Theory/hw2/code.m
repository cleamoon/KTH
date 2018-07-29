sysmp = minphase;  % CHANGE WHEN CHANGE CASE
A = sysmp.A;
B = sysmp.B;
C = sysmp.C;
D = sysmp.D;

s = tf('s');
G = C*inv(s*eye(4, 4) - A)*B + D;
fprintf('The transfer matrix is the following\n');
G
fprintf('Pole of G(1, 1) is %f\n', pole(G(1, 1)));
fprintf('Zero of G(1, 1) is %f\n', tzero(G(1, 1)));
fprintf('Pole of G(1, 2) is %f\n', pole(G(1, 2)));
fprintf('Zero of G(1, 2) is %f\n', tzero(G(1, 2)));
fprintf('Pole of G(2, 1) is %f\n', pole(G(2, 1)));
fprintf('Zero of G(2, 1) is %f\n', tzero(G(2, 1)));
fprintf('Pole of G(2, 2) is %f\n', pole(G(2, 2)));
fprintf('Zero of G(2, 2) is %f\n\n', tzero(G(2, 2)));

fprintf('Pole of G is %f\n', pole(G));
fprintf('Zero of G is %f\n', tzero(G));

for w = [0 0.001 0.01 0.1 1 2 5 10 20]
    eigs = eig(evalfr(G, i*w)'*evalfr(G, i*w));
    fprintf('The largest singular values for G at frequency %f is %f \n', w, max(eigs));
    fprintf('The smallest singular values for G at frequency %f is %f \n', w, min(eigs));
end

fprintf('H inf norm for G is %f \n', norm(G, inf));

RGA0 = evalfr(G, 0).*(inv(evalfr(G, 0)))';
fprintf('The RGA of the system at frequency 0 is\n');
disp(RGA0)
omega_c = 0.1;                              % CHANGE WHEN CHANGE CASE
phim = pi/3;
argg = angle(evalfr(G(1,1), 1i*omega_c));   % CHANGE WHEN CHANGE CASE
fprintf('Arg(g11(i wc)) is %f\n', argg);    % CHANGE WHEN CHANGE CASE
Ti1 = tan(-pi/2+phim-argg)/omega_c;
fprintf('Ti1 is %f\n', Ti1);
l1 = G(1,1)*(1+1/(s*Ti1));                  % CHANGE WHEN CHANGE CASE
K1 = 1/abs(evalfr(l1, 1i*omega_c));
fprintf('K is %f\n', K1);
f1 = K1 * (1 + 1/(s*Ti1));
argg = angle(evalfr(G(2,2), 1i*omega_c));   % CHANGE WHEN CHANGE CASE
fprintf('Arg(g22(i wc)) is %f\n', argg);    % CHANGE WHEN CHANGE CASE
Ti2 = tan(-pi/2+phim-argg)/omega_c;
fprintf('Ti2 is %f\n', Ti2)
l2 = G(2,2)*(1+1/(s*Ti2));                  % CHANGE WHEN CHANGE CASE
K2 = 1/abs(evalfr(l2, 1i*omega_c));
fprintf('K is %f\n', K2);
f2 = K2 * (1 + 1/(s*Ti2));
F = [f1, 0; 0, f2];                         % CHANGE WHEN CHANGE CASE
L = G*F;
S = inv(eye(2,2) + L);
T = S*L;
[~, Singular_of_S, ~] = svd(evalfr(S, 1i*omega_c))
[~, Singular_of_T, ~] = svd(evalfr(T, 1i*omega_c))

% AFTER SIMULINK
figure()
plot(uout)
title('Input')
figure()
plot(yout)
title('Output')
