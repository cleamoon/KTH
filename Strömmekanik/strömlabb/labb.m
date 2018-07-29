%% Fluid mechanics lab
clear all;


%% Task 0 
T = 23 + 273.15;
T0 = 273.11;
S = 110.56;
mu0 = 1.7894e-5;
mu = mu0*(T/T0)^(3/2)*(T0+S)/(T+S);
patm = 99260;
R = 287;
rho = patm/R/T;
nu = mu/rho;


%% Task 1
nr_bad1 = 3;
[Y1, Uy1] = read_lab_data_JF2('FPG_GRP16_500', nr_bad1); % 1.jpg
nr_bad2 = 4;
[Y2, Uy2] = read_lab_data_JF2('FPG_GRP16_740', nr_bad2); % 2.jpg
[Ywall1, ny1] = FPG_LAB_JF_P1(Y1, Uy1); % 3.jpg
[Ywall2, ny2] = FPG_LAB_JF_P1(Y2, Uy2); % 4.jpg
ny_av = (ny1+ny2)/2;
Ue1 = mean(Uy1(end-3:end));
Ue2 = mean(Uy2(end-3:end));
Y1 = Y1-Ywall1;
Y2 = Y2-Ywall2;
Y1 = [0; Y1];
Y2 = [0; Y2];
Uy1 = [0; Uy1];
Uy2 = [0; Uy2];
delta_s1 = trapz(Y1, 1-Uy1./Ue1);
delta_s2 = trapz(Y2, 1-Uy2./Ue2);
theta1 = trapz(Y1, (1-Uy1./Ue1).*Uy1./Ue1);
theta2 = trapz(Y2, (1-Uy2./Ue2).*Uy2./Ue2);
H1 = delta_s1 / theta1;
H2 = delta_s2 / theta2;
H_av = (H1+H2)/2;
[f, fp, fpp, fppp, eta] = FS_solver_JF(ny_av);
b = trapz(eta, 1-fp);

figure;  % 5.jpg
hold on;
title('Uy / Y plot');
xlabel('Uy (m/s)');
ylabel('Y (mm)')
plot(Uy1, Y1, 'r*-');
plot(Uy2, Y2, 'b*-');
legend('Velocity profile at 500mm', 'Velocity profile at 740mm', 'Location', 'north');

figure; % 6.jpg
hold on;
title('(Uy/Ue) / (Y/delta) plot');
xlabel('Uy/Ue');
ylabel('Y/delta*')
plot(Uy1/Ue1, Y1/delta_s1, 'r*-');
plot(Uy2/Ue2, Y2/delta_s2, 'b*-'); 
s = 80;
plot(fp(1:s), eta(1:s)/b, 'm-');  
legend('Velocity profile at 500mm', 'Velocity profile at 740mm', 'Falkner-Skan profile', 'Location', 'north');
plot([1,1], [0, ceil(max(Y1(end)/delta_s1, Y2(end)/delta_s2))], 'g-');


%% Task 2
rho_meth=776;
g=9.82;
beta=20;
[X, h] = read_lab_data_JF3('gr16');
Dh = h(1:end-1)-h(end);
Dp=rho_meth*g*Dh*sin(beta);
Ux = sqrt(2*Dp/rho);
[nx] = Ufit_JF(X, Ux);


%% Task 4
delta = delta_s1/b;
cf_theo = 2*nu/delta/Ue1*fpp(1)*1000;
n1 = ny1;
n2 = nx;
c = theta1/delta_s1*b;
Re_theta = Ue1*theta1/1000/nu;
cf_exp1 = 2*(c^2*(1-n1)/2*1/(Re_theta)+n1*(c/(Re_theta))^2*Ue1/nu*(delta_s1+2*theta1)/1000);
cf_exp2 = 2*(c^2*(1-n2)/2*1/(Re_theta)+n2*(c/(Re_theta))^2*Ue1/nu*(delta_s1+2*theta1)/1000);

p1 = cf_exp1/cf_theo;
p2 = cf_exp2/cf_theo;

