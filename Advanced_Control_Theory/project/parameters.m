
%% Minphase
clear all
Area = 15.52; % cm2 Tank coss section area
kc = 0.2; % V/cm   Sensor prop
gamma = 0.625; % Minphase
g = 9.81;

% Decide a1, a2, a3, a4, k1 and k2
%% Calculate k1
h0k1 = [10, 20, 30, 40, 50, 60] * 0.0025;    % Percentage of 25 cm
h1k1 = [20, 30, 40, 50, 60, 70] * 0.0025;
t0k1 = [3.7, 4.9, 6.2, 7.3, 8.5, 9.8];
t1k1 = [4.9, 6.2, 7.3, 8.5, 9.8, 11.0];
uk1  = [50] * 0.15;

k1 = CalcK(h0k1, h1k1, t0k1, t1k1, uk1);
%% Calculate k2
h0k2 = [10, 20, 30, 40, 50, 60] * 0.0025;
h1k2 = [20, 30, 40, 50, 60, 70] * 0.0025;
t0k2 = [4.0, 5.4, 6.6, 8.0, 9.2, 10.6];
t1k2 = [5.4, 6.6, 8.0, 9.2, 10.6, 11.9];
uk2  = [50] * 0.15;

k2 = CalcK(h0k2, h1k2, t0k2, t1k2, uk2);

%% Calculate output areas from single tanks

% [a1, a2, a3, a4] = CalcAreas(h1,h2,h3,h4,k1,k2,u1,u2,gamma);
% h = [0.38*25, 0.33*25, 15.5, 19, 23, 21];
h = [0.38*25, 0.33*25, 19, 15.5, 23, 21];
u = [50, 50, 20, 20, 50, 50] * 0.01 * 15;
k = [k1, k2, k1, k2, k1, k2];
hole_areas = CalcAreas(h, u, k)

%% Calculate output areas From steady state
gamma = 0.625; % Minphase
%h1 = [0.4 * 25];
%h2 = [0.28 * 25];
%h3 = [9.5];
%h4 = [8];
h1 = [0.43 * 25];
h2 = [0.30 * 25];
h3 = [12.9];
h4 = [8.8];
u1 = [7.5];
u2 = [7.5];
[a1, a2, a3, a4] = CalcAreasSS( h1, h2, h3, h4, k1, k2, u1, u2, gamma);
hole_areas_ss = [a1, a2, a3, a4];
ss_h = [h1, h2, h3, h4];

%% Calculate output areas From non-minphase steady state
gamma = 1 - 0.625; % Minphase
%h1 = [0.4 * 25];
%h2 = [0.28 * 25];
%h3 = [9.5];
%h4 = [8];
h1 = [0.32 * 25];
h2 = [0.30 * 25];
h3 = [6];
h4 = [8];
u1 = [7.5];
u2 = [7.5];
[a1, a2, a3, a4] = CalcAreasSS( h1, h2, h3, h4, k1, k2, u1, u2, gamma);
hole_areas_ss_n = [a1, a2, a3, a4];
ss_h = [h1, h2, h3, h4];

%% Calc steady state minphase
gamma = 0.625; % Minphase
gammaC = 1 - gamma;
u1 = 7.5;
u2 = 7.5;
a1 = hole_areas(1);
a2 = hole_areas(2);
a3 = hole_areas(3);
a4 = hole_areas(4);

h1c = (gammaC * k2 * u2 + gamma * k1 * u1)^2/(2 * a1^2 * g);
h2c = (gammaC * k1 * u1 + gamma * k2 * u2)^2/(2 * a2^2 * g);
h3c = (gammaC * k2 * u2)^2/(2 * a3^2 * g);
h4c = (gammaC * k1 * u1)^2/(2 * a4^2 * g);
ss_h_c = [h1c, h2c, h3c, h4c]

%% Calc steady state non-minphase
gamma = 0.375; % Non Minphase
gammaC = 1 - gamma;
u1 = 7.5;
u2 = 7.5;
a1 = hole_areas(1);
a2 = hole_areas(2);
a3 = hole_areas(5);
a4 = hole_areas(6);

h1cn = (gammaC * k2 * u2 + gamma * k1 * u1)^2/(2 * a1^2 * g);
h2cn = (gammaC * k1 * u1 + gamma * k2 * u2)^2/(2 * a2^2 * g);
h3cn = (gammaC * k2 * u2)^2/(2 * a3^2 * g);
h4cn = (gammaC * k1 * u1)^2/(2 * a4^2 * g);

ss_h_cn = [h1cn, h2cn, h3cn, h4cn]

%% Calc controller Minphase
robustify = 1;
isMinphase = 1;
[A, By, C, Dy] = CalcController(k1, k2, hole_areas(1:4), ss_h_c, Area, isMinphase, robustify)

%% Calc controller Non-Minphase
robustify = 1;
isMinphase = 0;
[A, By, C, Dy] = CalcController(k1, k2, [hole_areas(1:2), hole_areas(5:6)], ss_h_cn, Area, isMinphase, robustify)
%% Save Controller
save regX.MAT A By C Dy isMinphase robustify
