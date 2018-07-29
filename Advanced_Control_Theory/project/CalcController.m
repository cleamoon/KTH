function [ A, By, C, Dy ] = CalcController(k1, k2, hole_areas, ss_heights, Area, isMinphase, robustify)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
alpha = 1.1;
g = 9.81;
if isMinphase == 1
    gamma = 0.625;
else
    gamma = 1-0.625;
end
T = (Area./hole_areas(1:4)) .* sqrt(2.*ss_heights ./ g);
Amat = diag(-1./T);
Amat(1, 3) = 1./T(3);
Amat(2, 4) = 1./T(4);
B = [gamma*k1/Area, 0;
    0,  gamma*k2/Area;
    0,  (1-gamma)*k2/Area;
    (1-gamma)*k1/Area, 0];
%C = [kc, 0, 0, 0;   % C if measurements are in voltage to cm
%     0, kc, 0, 0];
 C = [0.25, 0, 0, 0;    % if measurements are in percentage
     0, 0.25, 0, 0];
if isMinphase = 1
    Gss = minphase;
else
    Gss = nonminphase; 
end
% Gss = ss(Amat, B, C, []);
G = tf(Gss);

% Decoupling 
if isMinphase == 1
    wcw = 0.1; % rad/s for minphase
    W1 = minreal([1 , -G(1,2)/G(1,1); -G(2,1)/G(2,2), 1]);
    W2 = eye(2);
else
    wcw = 0.02;
    s = tf('s');
    W1 = minreal(10*wcw/(s+10*wcw) * [-G(2,2)/G(2,1), 1; 1, -G(1,1)/G(1,2)]);
    W2 = eye(2);
end
G_tilde = minreal(W2 * G * W1);
% design PI controller
pm = pi/3;
F_tilde = shapeLoop(G_tilde, wcw, pm);

% Robustify 8
L0 = minreal(ss(minreal(ss(G) * ss(W1) * ss(F_tilde))));
[Fr, gam] = rloop(L0, alpha);

if robustify == 1
    F = minreal(W1 * F_tilde * Fr); % with robustification
else
    F = minreal(W1 * F_tilde);   % Without robustification
end
L = minreal(G*F);
if isMinphase == 1
    margin(L(1,1));
else
%     margin(L(1,1));
    bode(L)
end
Fss = ss(F, 'min');
[A, By, C, Dy] = ssdata(Fss);
end

