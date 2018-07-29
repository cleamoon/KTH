clear all

%% Question 0 - Air Air density and viscosity
% The temperature is T. 
% The air dynamic viscosity of air is mu. 
% The atomspheric pressure is Patm. 
T0=273.11;
T=23.8+T0;
Patm=1006.1*100;
mu0=1.7894e-5;
R=287;
S=110.56;
mu=mu0*(T/T0).^(3/2)*((T0+S)/(T+S))
rho=Patm/R/T
nu=mu/rho

%% Question 1 - Profile
% EXPERIMENTAL PROFILE
% 1 point resp 2 points should be omitted from two data sets. 
clf('reset');
% For the first position at x=66cm
[delta_star_expe1, delta_star_teore1, H1, f1, fp1, fpp1, fppp1, eta1, b1, Uy1, Ue1, theta1, delta1, Y1, ny1] = calc_profiles(66, 1, nu);
disp ('The experimental \delta* for x=66cm is ')
disp (delta_star_expe1)
disp ('The theoretical \delta* for x=66cm is ')
disp (delta_star_teore1)
Y1 = [0; Y1];
Uy1 = [0; Uy1];

% For the second position at x=50cm
[delta_star_expe2, delta_star_teore2, H2, f2, fp2, fpp2, fppp2, eta2, b2, Uy2, Ue2, theta2, delta2, Y2, ny2] = calc_profiles(50, 2, nu);
disp ('The experimental \delta* for x=50cm is ')
disp (delta_star_expe2)
disp ('The theoretical \delta* for x=50cm is ')
disp (delta_star_teore2)
Y2 = [0; Y2];
Uy2 = [0; Uy2];

%plotting
figure(1), clf
plot(Uy1, Y1, 'r-', Uy2, Y2, '--')
title('Unscaled Y/U')
ylabel('Y(mm)')
xlabel('U(m/s)')
hold on;
figure(2), clf
plot(Uy1/Ue1, Y1/delta_star_expe1/1000, 'r-', Uy2/Ue2, Y2/delta_star_expe2/1000, '--', ones(size(Uy1)), 0:0.2:7.8, 'b.')
title('Scaled Y/U')
ylabel('Y/\delta*')
xlabel('U/Ue')
hold on;


%% Question 2 - Free stream velocity variation
[X, h] = read_lab_data_JF3('h');
X = X/100;
h = h/100;
rho_m = 776;
g = 9.82; 
beta = 20*pi/180;
Dhtot = h(end);
Dhstat = h(1:end-1);
Dp = rho_m * g * (Dhstat - Dhtot) * sin(beta);
Ux = sqrt(2*Dp/rho);
[nx] = Ufit_JF(X, Ux);


%% Question 4 - Skin-friction coefficient comparison between experiment and theory
% Theoritical cf
b = delta_star_teore1 / delta1;
deltap = delta_star_expe1 / b;
cf_theo = 2*nu/deltap/Ue1*fpp1(1)
% Experimental cf
c1 = theta1 / deltap;
Re_theta1 = Ue1*theta1/nu;
cf_exp1 = 2*( c1^2*(1-ny1)/2/Re_theta1 + ny1*(c1/Re_theta1)^2*Ue1/nu*(delta_star_expe1+2*theta1) )
cf_exp2 = 2*( c1^2*(1-nx)/2/Re_theta1 + nx*(c1/Re_theta1)^2*Ue1/nu*(delta_star_expe1+2*theta1) )

% ratio
r1 = cf_exp1/cf_theo
r2 = cf_exp2/cf_theo