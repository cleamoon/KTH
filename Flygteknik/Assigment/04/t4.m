%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Home assignment 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clc;
clear all;
entete;

format long

%% Parameters

g=9.81; %m/s^2
CD0=0.024;
W=10E3; %Weight (N)
WS=800; %N/m^2
S=W/WS;
PmaxW=20; %W/N
cprime=0.25/(3600*1E3); %kg/J;
K=0.065;
eta_pr=0.8; %Propeller efficiency
range=500E3; %Total flight range (m)

gamma=1.4;
T_tropo=-56.5+273.15;
h_tropo=11e3;
Tssl=15+273.15; %Temperature at z=0 SSL (K)
Pssl=101.325E3; %SSL pressure (Pa)
R=287.0529; %Gas constant (normalised with air) (J/kg/K)
%rhossl=Pssl/(R*Tssl); %SSL density (kg/m^3)
rhossl=1.225;

step_h=1;
h_cruise=2E3; %Cruise altitude (m)
h=[0:step_h:h_cruise]; %Altitude vector (m)
[P_inf, rho_inf, T_inf, c_inf]=atm_parameters(h,T_tropo,h_tropo,...
    Tssl,Pssl,rhossl); %Atmosphere parameters
 

%% Task 1

Pmaxh=PmaxW*(rho_inf/rhossl);
    
V_RC_max=( (2./rho_inf) * (K/(3*CD0))^(1/2) * WS ).^(1/2);

RCmax=eta_pr*Pmaxh - (2/sqrt(3))*V_RC_max*sqrt(4*CD0*K);

%theta_max=asind(eta_pr*Pmaxh./V_RC_max - (1/2)*CD0*rho_inf.*V_RC_max.^2/WS...
    %- K*WS*2./(V_RC_max.^2.*rho_inf)); %Maximum climb angle
    
theta_max=asind(RCmax./V_RC_max);

h_reduced=h(1:500:end);
RCmax_red=RCmax(1:500:end);
theta_max_red=theta_max(1:500:end);
V_RC_max_red=V_RC_max(1:500:end);

theta_max=asind(RCmax./V_RC_max);

tt = [h_reduced; RCmax_red; theta_max_red; V_RC_max_red];
tt = tt';
xlswrite('d1.xlsx',tt);

%{
FID = fopen('HA4_Task1.tex', 'w');
fprintf(FID, '\\begin{tabular}{|cccc|} \\hline \n');
fprintf(FID, 'h (m) & $(R/C)_{max} (m/s)$ & $\\theta_{max} (^\\circ)$ & $V_{RC_{max}} (m/s)$  \\\\ \\hline \n');
for k=1:length(h_reduced)
    fprintf(FID, '%8.2f & %8.2f & %8.2f & %8.2f \\\\ ', h_reduced(k), RCmax_red(k),theta_max_red(k),V_RC_max_red(k));
    if k==length(h_reduced)
        fprintf(FID, '\\hline ');
    end
    fprintf(FID, '\n');
end
 
fprintf(FID, '\\end{tabular}\n');
fclose(FID);
%}

%% Task 2 - Mission 1

t_2000=trapz(h(1:end),1./RCmax(1:end)); %Time to climb up to the cruise altitude
V_H=V_RC_max.*cos(theta_max*pi/180); %Horizontal velocity
%x_horiz=trapz(h(1:end),abs(V_H(1:end)./RCmax(1:end))); %Horizontal range of flight
x_horiz=trapz(h(1:end),1./tand(theta_max));
disp('Mission 1')
[hour2, mins2, secs2] = sec2hms(t_2000);
disp(['Climb time from 0 to 2km:  ',num2str(hour2),' hour ',num2str(mins2),' min ',num2str(secs2),' s'])

disp(['Horizontal range covered:  ',num2str(x_horiz),])
disp(' ')

%% Task 3 - Mission 2

V_carson=( (2*WS./rho_inf)*sqrt(3*K/CD0) ).^(1/2);
RCcarson=eta_pr*Pmaxh - 4*(CD0*K/3)^(1/2)*V_carson;
theta_max_carson=(180/pi)*asin(eta_pr*Pmaxh./V_carson - (1/2)*CD0*rho_inf.*V_carson.^2/WS...
    - K*WS*2./(V_carson.^2.*rho_inf)); %Maximum climb angle

t_2000_carson=trapz(h(1:end),1./RCcarson(1:end)); %Time to climb up to the cruise altitude
V_H_carson=V_carson.*cos(theta_max_carson*pi/180); %Horizontal velocity
x_horiz_carson=trapz(h(1:end),abs(V_H_carson(1:end)./RCcarson(1:end))); %Horizontal range of flight

disp('Mission 2')
[hour2, mins2, secs2] = sec2hms(t_2000_carson);
disp(['Climb time from 0 to 2km:  ',num2str(hour2),' hour ',num2str(mins2),' min ',num2str(secs2),' s'])

disp(['Horizontal range covered:  ',num2str(x_horiz_carson),])
disp(' ')

h_reduced=h(1:500:end);
RCmax_red=RCcarson(1:500:end);
theta_max_red=theta_max_carson(1:500:end);
V_RC_max_red=V_carson(1:500:end);

theta_max=asind(RCmax./V_RC_max);

tt2 = [h_reduced; RCmax_red; theta_max_red; V_RC_max_red];
tt2 = tt2';
xlswrite('d3.xlsx',tt2);

%{
FID = fopen('HA4_Task3.tex', 'w');
fprintf(FID, '\\begin{tabular}{|cccc|} \\hline \n');
fprintf(FID, 'h (m) & $(R/C)_{max} (m/s)$ & $\\theta_{max} (^\\circ)$ & $V_{RC_{max}} (m/s)$  \\\\ \\hline \n');
for k=1:length(h_reduced)
    fprintf(FID, '%8.2f & %8.2f & %8.2f & %8.2f \\\\ ', h_reduced(k), RCmax_red(k),theta_max_red(k),V_RC_max_red(k));
    if k==length(h_reduced)
        fprintf(FID, '\\hline ');
    end
    fprintf(FID, '\n');
end
 
fprintf(FID, '\\end{tabular}\n');
fclose(FID);
%}

%% Task 4

m0=W/g; %Initial mass

% Mission 1 

theta_max=(pi/180)*theta_max;
theta_mean=mean(theta_max);

CL_1=sqrt(3*CD0/K);
CD_1=CD0+K*CL_1^2;

R_coeff=(eta_pr/(cprime*g))*(CL_1/CD_1)*cos(theta_mean)/(cos(theta_mean)+(CL_1/CD_1)*sin(theta_mean));

m_11=m0*exp(-x_horiz/R_coeff); %At the end of the first segment (climb part)
m_conso_climb1=m0-m_11;

weight_ratio11=m_11/m0;


disp('Mission 1')
disp(['Fuel consumption climb part ',num2str(m_conso_climb1),'kg'])
disp(['Mass ratio ',num2str(weight_ratio11),])
disp(' ')

%% Task 5 - Cruise part, mission 1

cruise_range1=range-x_horiz;

CL_1=sqrt(CD0/K);
CD_1=2*CD0;

Vminthrust=sqrt(2*(m_11*g/S)/rho_inf(length(h))*sqrt(K/CD0));

R_coeff=eta_pr/(cprime*g)*CL_1/CD_1;
m_12=m_11*exp(-cruise_range1/R_coeff);
m_conso_cruise1=m_11-m_12;

m_conso_total1=m_conso_climb1+m_conso_cruise1;

weight_ratio12=m_12/m_11; %Weight ratio between the beginning of the cruise and the end

endurance=(R_coeff/Vminthrust)*log(m_11/m_12);
[hour3, mins3, secs3] = sec2hms(endurance);
alt_fin1=2355; %(m)

disp(['Mission 1'])
disp(['Fuel consumption cruise part ',num2str(m_conso_cruise1),'kg'])
disp(['Fuel consumption - total ',num2str(m_conso_total1),'kg'])
disp(['Weight ratio cruise part ',num2str(weight_ratio12)])
disp(['Endurance ', num2str(hour3),'h ',num2str(mins3),' min ',num2str(secs3),' s'])
disp(' ')


%% Task 6

% Mission 2 - climb part

theta_max_carson=(pi/180)*theta_max_carson;
theta_mean_carson=mean(theta_max_carson);

CL_2=sqrt(CD0/(3*K));
CD_2=CD0+K*CL_2^2;

R_coeff=(eta_pr/(cprime*g))*(CL_2/CD_2)*cos(theta_mean_carson)/(cos(theta_mean_carson)...
        +(CL_2/CD_2)*sin(theta_mean_carson));

m_21=m0*exp(-x_horiz_carson/R_coeff); %At the end of the first segment (climb part)
m_conso_climb2=m0-m_21;
weight_ratio21=m_21/m0;

cruise_range2=range-x_horiz_carson;

V_carson_cruise=sqrt(2*(m_21*g/S)./rho_inf(length(h))*sqrt(3*K/CD0));

R_coeff=eta_pr/(cprime*g)*CL_2/CD_2;
m_22=m_21*exp(-cruise_range2/R_coeff);
m_conso_cruise2=m_21-m_22;

m_conso_total2=m_conso_climb2+m_conso_cruise2;

weight_ratio22=m_22/m_21; %Weight ratio between the beginning of the cruise and the end

endurance=(R_coeff/V_carson_cruise)*log(m_21/m_22);
[hour4, mins4, secs4] = sec2hms(endurance);

alt_fin2=2373 ; % (m)

disp('Mission 2')
disp(['Fuel consumption climb part ',num2str(m_conso_climb2),'kg'])
disp(['Mass ratio climb part ',num2str(weight_ratio21)])
disp(['Fuel consumption cruise part ',num2str(m_conso_cruise2),'kg'])
disp(['Fuel consumption - total ',num2str(m_conso_total2),'kg'])
disp(['Weight ratio cruise part ',num2str(weight_ratio22)])
disp(['Endurance ', num2str(hour4),'h ',num2str(mins4),' min ',num2str(secs4),' s'])
disp(' ')

%% Task 7

% Mission 1

rho_end1=weight_ratio12*rho_inf(length(h));

D=CD_1*0.5*rho_inf(2001)*Vminthrust^2*S; %Drag
PR_i=D*Vminthrust; %Power required
PA_i=W*PmaxW*rho_inf(2001)/rhossl; %Power available at the beginning of the cruise

ratio_i1=PR_i/PA_i;

D=CD_1*0.5*rho_end1*Vminthrust^2*S; %Drag
PR_e=D*Vminthrust; %Power required
PA_e=W*PmaxW*rho_end1/rhossl;

ratio_e1=PR_e/PA_e;

disp('Mission 1')
disp(['Power ratio at the beginning ',num2str(ratio_i1)])
disp(['Power ratio at the end ',num2str(ratio_e1)])
disp(' ')

% Mission 2

rho_end2=weight_ratio22*rho_inf(length(h));

D=CD_2*0.5*rho_inf(length(h))*V_carson_cruise^2*S; %Drag
PR_i=D*V_carson_cruise; %Power required
PA_i=W*PmaxW*rho_inf(length(h))/rhossl; %Power available at the beginning of the cruise

ratio_i2=PR_i/PA_i;

D=CD_2*0.5*rho_end2*V_carson_cruise^2*S; %Drag
PR_e=D*V_carson_cruise; %Power required
PA_e=W*PmaxW*rho_end2/rhossl; %Power available at the beginning of the cruise

ratio_e2=PR_e/PA_e;

disp('Mission 2')
disp(['Power ratio at the beginning ',num2str(ratio_i2)])
disp(['Power ratio at the end ',num2str(ratio_e2)])
disp(' ')

%% Task 8
Rearth = 6370*1000;
h_descent=500; %Altitude at which the aeroplane turns on the thrust again
h=[h_descent:step_h:alt_fin1]; %Altitude vector (m)

[P_gliding, rho_gliding, T_gliding, c_gliding]=atm_parameters(h,T_tropo,h_tropo,...
    Tssl,Pssl,rhossl); %Atmosphere parameters

theta_gliding=atand(CD_1/CL_1);
V_gliding=(2*(m_12*g*(Rearth)^2/(h_descent+Rearth)^2*cosd(theta_gliding)/S) ./ rho_gliding * sqrt(K/CD0)).^(1/2);

descent_range=(alt_fin1-h_descent)/tand(theta_gliding);

t_descent=trapz(h,1./(V_gliding*sind(theta_gliding)));

%h_reduced=h(1:500:1501);
%V_gliding=V_gliding(1:500:1501);

for k = [alt_fin1 2000 1500 1000 500]'
    tt = [h(k-500+1); ones(1,length(k))*theta_gliding; V_gliding(k-500+1)];
    tt = tt';
    xlswrite('d8.xlsx',tt);
end

%{
FID = fopen('HA4_Task8.tex', 'w');
fprintf(FID, '\\begin{tabular}{|cccc|} \\hline \n');
fprintf(FID, 'h (m) & $V_{gliding} (m/s)$ & $\\theta_{gliding} (^\\circ)$ \\\\ \\hline \n');
for k=1:length(h_reduced)
    fprintf(FID, '%8.2f & %8.2f & %8.2f  \\\\ ', h_reduced(k),V_gliding(k),theta_gliding);
    if k==length(h_reduced)
        fprintf(FID, '\\hline ');
    end
    fprintf(FID, '\n');
end
 
fprintf(FID, '\\end{tabular}\n');
fprintf(FID, 'Range = ',descent_range);
fprintf(FID, 'Time of gliding = ',t_descent);
fclose(FID);
%}

%% Task 9

CL_max=1.80;
h_descent=500; %Altitude at which the aeroplane turns on the thrust again
h=[0:step_h:500]; %Altitude vector (m)

[P_landing, rho_landing, T_landing, c_landing]=atm_parameters(h,T_tropo,h_tropo,...
    Tssl,Pssl,rhossl); %Atmosphere parameters

V_stall_landing=sqrt(2*m_12*g/(rhossl*S*CL_max));

theta_landing=3*ones(1,length(h)); % degrees

V_landing=(V_gliding(1)-1.3*V_stall_landing)/h_descent*h+1.3*V_stall_landing;

CL_landing=(m_12*g*cosd(theta_landing))./(rho_landing*0.5.*V_landing.^2*S);
CD0=CD0+0.008;
CL_CD_landing=CL_landing./(CD0+K*CL_landing.^2);

PR_W=V_landing.*(cosd(theta_landing)./CL_CD_landing-sind(theta_landing));
PR_landing=PR_W*m_12*g;
PAmaxSSL=PmaxW*W;
ratio_landing=PR_landing/PAmaxSSL;

landing_range=trapz(h,1./tan(degtorad(theta_landing)));
disp(['Landing horizontal range (m):  ',num2str(landing_range)])

time_landing=trapz(h,1./(V_landing.*sind(theta_landing)));
[hour6, mins6, secs6] = sec2hms(time_landing);
disp(['Landing time (s):  ',num2str(hour6),' hour ',num2str(mins6),' min ',num2str(secs6),' s'])
disp(' ')

h_reduced=h(1:100:end);
V_landing=V_landing(1:100:end);
CL_landing=CL_landing(1:100:end);
CL_CD_landing=CL_CD_landing(1:100:end);
PR_W=PR_W(1:100:end);
PR_landing=PR_landing(1:100:end);
ratio_landing=ratio_landing(1:100:end);
 
for k = 500:-100:0
    tt9 = [h_reduced(k/100+1);V_landing(k/100+1);CL_landing(k/100+1);...
        CL_CD_landing(k/100+1);PR_W(k/100+1);PR_landing(k/100+1);ratio_landing(k/100+1)];
    tt9 = tt9';
    xlswrite('d9.xlsx',tt9);
end

%{
FID = fopen('HA4_Task9.tex', 'w');
fprintf(FID, '\\begin{tabular}{|ccccccc|} \\hline \n');
fprintf(FID, 'h (m) & $V_{landing} (m/s)$ & $C_L$ & $C_L/C_D$ & $P_R/W (kW/N)$ & $P_R$ & Power ratio  \\\\ \\hline \n');
for k=1:length(h_reduced)
    fprintf(FID, '%8.2f & %8.2f & %8.2f %8.2f & %8.2f & %8.2f %8.2f \\\\ ', h_reduced(k),V_landing(k),CL_landing(k),...
        CL_CD_landing(k),PR_W(k),PR_landing(k),ratio_landing(k));
    if k==length(h_reduced)
        fprintf(FID, '\\hline ');
    end
    fprintf(FID, '\n');
end
 
fprintf(FID, '\\end{tabular}\n');
fprintf(FID, 'Range = ',descent_range);
fprintf(FID, 'Time of gliding = ',t_descent);
fclose(FID);
%}
