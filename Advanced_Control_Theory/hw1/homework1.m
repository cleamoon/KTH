%% 4.1
s = tf('s');
G = 3*(-s+1)/(5*s+1)/(10*s+1);
% F = 0.01396*(1+0.0175*s)/(1+0.4*s)*(1+28.664*s)/(1+0.4*s);
% hold on;
% bode(G);
w_c = 0.4;
[Gm,Pm,Wgm,Wpm] = margin(G);
[mag,phase] = bode(G, w_c);
% grid on; 
% figure;
% hold off;
shift = 50-(phase-180)+6;
beta = 0.17;
% beta = 0.2464;
phi_m = atan((1-beta)/(2*sqrt(beta)));
tau_D = 1/(w_c*sqrt(beta));
F_lead = (tau_D*s+1)/(beta*tau_D*s+1);
F_lead_des = abs(evalfr(F_lead, w_c*1i));
K = sqrt(beta)/abs(evalfr(G, w_c*1i));
tau_i = 10/w_c;
gamma = 0;
F_lag = (tau_i*s+1)/(tau_i*s+gamma);
[m_r, p_r] = bode(F_lead*F_lag*G, w_c);
F = K*F_lead*F_lag;
Gc = feedback(G*F,1);
step(Gc);
grid on;
stepinfo(Gc)
fprintf('Closed bandwidth is %f\n', bandwidth(Gc));
fprintf('Opened bandwidth is %f\n', bandwidth(G));
S =(minreal(feedback(eye(1), G*F)));
T = minreal(feedback(G*F,eye(1)));
fprintf('Closed M_T is %f\n', norm(T,inf))


%% 4.2.1
s = tf('s');
G = 20/(s+1)/((s/20)^2+(s/20)+1);
Gd = 10/(s+1);
w_c = sqrt(99);
Fy = w_c/s*(10*w_c/(s+10*w_c))^2/G;
Gc = minreal(Gd/(1+G*Fy));
step(Gc);
stepinfo(Gc)
bandwidth(Gc)

%% 4.2.2
s = tf('s');
G = 20/(s+1)/((s/20)^2+(s/20)+1);
Gd = 10/(s+1);
w_c = sqrt(99);
Fy = (s+w_c/2)/s*(10*w_c/(s+10*w_c))^2/G*Gd;
Gc = minreal(Gd/(1+G*Fy));
step(Gc);
stepinfo(Gc)
bandwidth(Gc)

%% 4.2.3
s = tf('s');
G = 20/(s+1)/((s/20)^2+(s/20)+1);
Gd = 10/(s+1);
w_c = sqrt(99);
Fy = (s+w_c/2)/s*(10*w_c/(s+10*w_c))^2/G*Gd;
N = 3;
b = (w_c+4)/sqrt(N);
F_lead = N*(s+b)/(s+b*sqrt(N));
K = 1 / evalfr(F_lead*Fy, w_c+4) / evalfr(G, w_c+4);
F = K*F_lead*Fy;
Gc = minreal(G*F/(1+G*F));
step(Gc);
stepinfo(Gc)


%% 4.2.4
s = tf('s');
G = 20/(s+1)/((s/20)^2+(s/20)+1);
Gd = 10/(s+1);
w_c = sqrt(99);
Fy = (s+w_c/2)/s*(10*w_c/(s+10*w_c))^2/G*Gd;
N = 1.5;
b = (w_c+4)/sqrt(N);
F_lead = N*(s+b)/(s+b*N);
K = 1 / evalfr(F_lead*Fy, w_c+4) / evalfr(G, w_c+4);
F = K*F_lead*Fy;
%F = 1.2557*(0.0826*s+1)/(0.6565*0.0826*s+1)*Fy;
tau = 0.1;
Fr = 1/(1+tau*s);
Gcd = minreal(Gd/(1+G*F));
Gcr = minreal(G*F*Fr/(1+G*F));
Gcud = minreal(-F*Gd/(1+G*F));
Gcur = minreal(F*Fr/(1+G*F));
figure(1);
grid on;
step(Gcd);
stepinfo(Gcd)
figure(2);
grid on;
step(Gcr);
stepinfo(Gcr)
figure(3);
grid on;
step(Gcud);
stepinfo(Gcud)
figure(4);
grid on;
step(Gcur);
stepinfo(Gcur)