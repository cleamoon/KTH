clear all; close all;
format long

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% In Data %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cd0=0.024;      % drag polar data
K=0.065;        % drag polar data
W=10000;        % N
W_S=800;        % N/m^2
Pmax_W=18;      % W/N

% Cd0=0.024;
% K=0.075;
% W=10000; % N
% W_S=800;
% Pmax_W=20;

% Cd0=0.020;
% K=0.075;
% W=9000; % N
% W_S=900;
% Pmax_W=20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Other Parameters %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

etha=0.80; % efficiency
c=0.25; % specific fuel consumption (kg/kWh)
c=0.25/(3.6e6); % specific fuel consumption (kg/J)
rhoSSL=1.225; 
S=W/(W_S);

Range=500000; %(m)
h_cruise= 2000; % altitude of cruise
h_max=10000;

hstep=1;
[rho,a,h] = ISA(h_max,hstep);
rho_climb=rho(1:h_cruise+1);
h_climb=h(1:h_cruise+1);

% Task 1

Pmax_z=Pmax_W*(rho_climb/rhoSSL);
L_Dmax=1/sqrt(4*K*Cd0);

V_RCmax=sqrt(2*W_S./rho_climb*sqrt(K/(3*Cd0))); % Speed for maximum rate of climb
RCmax= etha*Pmax_z-(2/sqrt(3))*V_RCmax/L_Dmax; % Max rate of climb
theta_RCmax=radtodeg(asin(etha*Pmax_z./V_RCmax-Cd0*0.5*rho_climb.*V_RCmax.^2/W_S-K*W_S*2./(rho_climb.*V_RCmax.^2))); % Corresponding climb angle 

interval=500;
A=[h_climb RCmax theta_RCmax V_RCmax];
B = reduce_size(A,hstep,interval);

% Task 2

time1 = trapz(h_climb,1./RCmax);
[hour1, mins1, secs1] = sec2hms(time1);
disp('Mission 1')
disp(['Climbing time for 0 to 2km:  ',num2str(hour1),' hour ',num2str(mins1),' min ',num2str(secs1),' s'])

climb_range=trapz(h_climb,1./tan(degtorad(theta_RCmax)));
disp(['Horizontal range covered:  ',num2str(climb_range),])
disp(' ')

% Task 3

V_carson=sqrt(2*W_S./rho_climb*sqrt(3*K/Cd0));
RC_carson=etha*Pmax_z-4*V_carson*sqrt(Cd0*K/3);
theta_carson=radtodeg(asin(etha*Pmax_z./V_carson-Cd0*0.5*rho_climb.*V_carson.^2/W_S-K*W_S*2./(rho_climb.*V_carson.^2)));

A2=[h_climb RC_carson theta_carson V_carson];
B2 = reduce_size(A2,hstep,interval);

disp('Mission 2')
time2 = trapz(h_climb,1./RC_carson);
[hour2, mins2, secs2] = sec2hms(time2);
disp(['Climbing time for 0 to 2km:  ',num2str(hour2),' hour ',num2str(mins2),' min ',num2str(secs2),' s'])

climb_range2=trapz(h_climb,1./tan(degtorad(theta_carson)));
disp(['Horizontal range covered:  ',num2str(climb_range2),])
disp(' ')

% Task 4

g=9.81; 

% max rate of climb
CL_RCmax=sqrt(3*Cd0/K);
CD_RCmax=drag(CL_RCmax,K,Cd0);
CL_CD_RCmax=CL_RCmax/CD_RCmax;
[Mconso1,ratio1,Mfin1,Wfin] = conso(climb_range,theta_RCmax,CL_CD_RCmax,W,c,g,etha);
disp('Mission 1')
disp(['Fuel consumption at RCmax climbing (kg):  ',num2str(Mconso1),])
disp(['Mfinal/Mini:  ',num2str(ratio1),])
disp(' ')

%carson
CL_carson=sqrt(Cd0/(3*K));
CD_carson=(4/3)*Cd0;
CL_CD_carson=CL_carson/CD_carson;
[Mconso2,ratio2,Mfin2,Wfin2] = conso(climb_range2,theta_carson,CL_CD_carson,W,c,g,etha);
disp('Mission 2')
disp(['Fuel consumption at Carson climbing (kg):  ',num2str(Mconso2),])
disp(['Mfinal/Mini:  ',num2str(ratio2),])
disp(' ')


% Task 5

disp('Mission 1')
CD_minthrust=2*Cd0;
CL_minthrust=sqrt(Cd0/K);
CL_CD_minthrust=1/(2*sqrt(Cd0*K));
Vminthrust=sqrt(2*(Wfin/S)/rho(h_cruise+1)*sqrt(K/Cd0));
% % Vminthrust=sqrt(2*W_S/rho(h_cruise+1)*sqrt(K/Cd0));
[cruise_range,ratio_cruise,Mconso_cruise,endurance,altitude_fin,Wfin_cruise]=task5(Range,climb_range,Mfin1,c,g,rho,h_cruise+1,h,CL_CD_minthrust,Vminthrust,etha);
[hour3, mins3, secs3] = sec2hms(endurance);
disp(['Cruise range (m):  ',num2str(cruise_range),])
disp(['Weigth ratio:  ',num2str(ratio_cruise),])
disp(['Fuel consumption cruise(kg):  ',num2str(Mconso_cruise),])
disp(['Endurance:  ',num2str(hour3),' hour ',num2str(mins3),' min ',num2str(secs3),' s'])
disp(['Altitude at the end of the cruse (m):  ',num2str(altitude_fin),])
disp(' ')

% Task 6

disp('Mission 2')
%V_carson_cruise=sqrt(2*W_S./rho(h_cruise+1)*sqrt(3*K/Cd0));
V_carson_cruise=sqrt(2*(Wfin2/S)./rho(h_cruise+1)*sqrt(3*K/Cd0));
[cruise_range2,ratio_cruise2,Mconso_cruise2,endurance2,altitude_fin2,Wfin_cruise2]=task5(Range,climb_range2,Mfin2,c,g,rho,h_cruise+1,h,CL_CD_carson,V_carson_cruise,etha);
[hour4, mins4, secs4] = sec2hms(endurance2);
disp(['Cruise range (m):  ',num2str(cruise_range2),])
disp(['Weigth ratio:  ',num2str(ratio_cruise2),])
disp(['Fuel consumption cruise(kg):  ',num2str(Mconso_cruise2),])
disp(['Endurance:  ',num2str(hour4),' hour ',num2str(mins4),' min ',num2str(secs4),' s'])
disp(['Altitude at the end of the cruse (m):  ',num2str(altitude_fin2),])
disp(' ')

% Task 7

Pmax_zcruise=W*Pmax_W*(rho/rhoSSL);

PA_debut=Pmax_zcruise(h_cruise);
PR_debut=power_required(Vminthrust,h_cruise,rho,S,CD_minthrust);

ratio_power_debut=PR_debut/PA_debut;

PA_fin=Pmax_zcruise(altitude_fin);
PR_fin=power_required(Vminthrust,altitude_fin,rho,S,CD_minthrust);

ratio_power_fin=PR_fin/PA_fin;

disp('Mission 1')
disp(['PR/PA ratio debut of the cruise:  ',num2str(ratio_power_debut)])
disp(['PR/PA ratio end of the cruise:  ',num2str(ratio_power_fin)])
disp('  ')



PA_debut2=Pmax_zcruise(h_cruise);
PR_debut2=power_required(V_carson_cruise,h_cruise,rho,S,CD_carson);

ratio_power_debut2=PR_debut2/PA_debut2;

PA_fin2=Pmax_zcruise(altitude_fin2);
PR_fin2=power_required(V_carson_cruise,altitude_fin2,rho,S,CD_carson);

ratio_power_fin2=PR_fin2/PA_fin2;

disp('Mission 2')
disp(['PR/PA ratio debut of the cruise:  ',num2str(ratio_power_debut2)])
disp(['PR/PA ratio end of the cruise:  ',num2str(ratio_power_fin2)])
disp('  ')

% Task 8

rho_gliding=rho(500+1:altitude_fin+1);
h_gliding=h(500+1:altitude_fin+1);
V_gliding=sqrt(sqrt(K/Cd0)*2*Wfin_cruise./(rho_gliding*S));

theta_gliding=radtodeg(asin(1/CL_CD_minthrust))*ones(length(h_gliding),1);
% theta_gliding=radtodeg(acos(V_gliding.^2.*rho_gliding*CL_minthrust*S/(2*Wfin_cruise)));

A3=[h_gliding V_gliding theta_gliding];
B3 = reduce_size(A3,hstep,interval);
B3=flipud(B3);

gliding_range=trapz(h_gliding,1./tan(degtorad(theta_gliding)));
disp(['Gliding horizontal range (m):  ',num2str(gliding_range)])

time_gliding=trapz(h_gliding,1./(V_gliding.*sind(theta_gliding)));
[hour5, mins5, secs5] = sec2hms(time_gliding);
disp(['Gliding time (s):  ',num2str(hour5),' hour ',num2str(mins5),' min ',num2str(secs5),' s'])
disp(' ')

% Task 9

rho_landing=rho(1:500+1);
h_landing=h(1:500+1);
V_stall_landing=sqrt(2*Wfin_cruise/(rhoSSL*S*1.80));
theta_landing=3*ones(length(h_landing),1); % degres
V_landing=(V_gliding(1)-1.3*V_stall_landing)/500*h_landing+1.3*V_stall_landing;
CL_landing=(Wfin_cruise.*cosd(theta_landing))./(rho_landing.*0.5.*V_landing.^2*S);
Cd0=Cd0+0.008;
CL_CD_landing=CL_landing./(Cd0+K*CL_landing.^2);
PR_W=V_landing.*(cosd(theta_landing)./CL_CD_landing-sind(theta_landing));
PR_landing=PR_W*Wfin_cruise;
PAmaxSSL=Pmax_W*W;
ratio_landing=PR_landing/PAmaxSSL;

interval2=100;
A4=[h_landing V_landing CL_landing CL_CD_landing PR_W PR_landing ratio_landing];
B4 = reduce_size(A4,hstep,interval2);
B4=flipud(B4);

landing_range=trapz(h_landing,1./tan(degtorad(theta_landing)));
disp(['Landing horizontal range (m):  ',num2str(landing_range)])

time_landing=trapz(h_landing,1./(V_landing.*sind(theta_landing)));
[hour6, mins6, secs6] = sec2hms(time_landing);
disp(['Landing time (s):  ',num2str(hour6),' hour ',num2str(mins6),' min ',num2str(secs6),' s'])
disp(' ')


