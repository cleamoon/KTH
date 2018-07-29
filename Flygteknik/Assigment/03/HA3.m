%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Home assigment 3 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clc;
clear all;
entete;

format long

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CD0 gamma K W_S rhossl TA_W_SL RCmax Tssl Pssl T_tropo h_tropo

CD0=0.020;
K=0.048;
W_S=1200; %Weight/m^2
TA_W_SL=0.28; %Ratio Thrust available/weight
CL_max=1.5;
gamma=1.4;

T_tropo=-56.5+273.15;
h_tropo=11e3;
Tssl=15+273.15; %Temperature at z=0 SSL (K)
Pssl=101.325E3; %SSL pressure (Pa)
R=287.0529; %Gas constant (normalised with air) (J/kg/K)
rhossl=Pssl/(R*Tssl); %SSL density (kg/m^3)

step_h=1;

h=[0:step_h:15e3]; %Altitude vector (m)

[P_inf, rho_inf, T_inf, c_inf]=atm_parameters(h,T_tropo,h_tropo,...
    Tssl,Pssl,rhossl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Task 1

TA_W=TA_W_SL*rho_inf/rhossl;

V_min=(1./(CD0*rho_inf)*W_S.*(TA_W-sqrt(TA_W.^2-4*K*CD0))).^(1/2);
V_max=(1./(CD0*rho_inf)*W_S.*(TA_W+sqrt(TA_W.^2-4*K*CD0))).^(1/2);
V_stall=(W_S*2./(rho_inf*CL_max)).^(1/2);
Mach_min=V_min./c_inf;
Mach_max=V_max./c_inf;
Mach_stall=V_stall./c_inf;

rho_ceil=rhossl*sqrt(4*K*CD0)/TA_W_SL;

[Ab,i_ceil1]=min(abs(rho_inf-rho_ceil));
h_ceil1=h(i_ceil1);
   

% FID = fopen('Task1.tex', 'w');
% fprintf(FID, '\\begin{tabular}{|ccccccc|}\\hline \n');
% fprintf(FID, 'h (km) & $V_{min} (m/s)$ & $M_{min}$ & $V_{max} (m/s)$ & $M_{min}$ & $V_{stall} (m/s)$ &$M_{stall}$ \\hline \n');
% for k=1:length(h)
%     fprintf(FID, '%8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f \\\\ ', h(k)/1000, V_min(k), Mach_min(k),...
%         V_max(k),Mach_max(k),V_stall(k),Mach_stall(k))
%     if k==length(h)
%         fprintf(FID, '\\hline ');
%     end
%     fprintf(FID, '\n');
% end
%  
% fprintf(FID, '\\end{tabular}\n');
% fclose(FID);

%% Task 2

Niter=1000;
eps=1e-5; %Accuracy on the Mach number
M_max=zeros(1,length(h));
M_min=zeros(1,length(h));

for i2=1:length(h)
    
M0_max=Mach_max(i2); %initial value
M0_min=Mach_min(i2); %initial value

M_max(i2)=newton_raph(M0_max,P_inf(i2),rho_inf(i2),eps,Niter);
M_min(i2)=newton_raph(M0_min,P_inf(i2),rho_inf(i2),eps,Niter);

end

% FID = fopen('Task1.tex', 'w');
% fprintf(FID, '\\begin{tabular}{|ccccccc|} \\hline \n');
% fprintf(FID, 'h (km) & $V_{min} (m/s)$ & $M_{min}$ & $V_{max} (m/s)$ & $M_{min}$  \\\\ \\hline \n');
% for k=1:length(h)
%     fprintf(FID, '%8.2f & %8.2f & %8.2f & %8.2f & %8.2f \\\\ ', h(k)/1000, M_min(k)*c_inf(k), M_min(k),...
%         M_max(k)*c_inf(k),M_max(k));
%     if k==length(h)
%         fprintf(FID, '\\hline ');
%     end
%     fprintf(FID, '\n');
% end
%  
% fprintf(FID, '\\end{tabular}\n');
% fclose(FID);
%% Task 3

h2=h/1000;

figure(1)
plot(V_min,h2,'r',V_max,h2,'b',V_stall,h2,'k')
hold on;
plot(M_min.*c_inf,h2,'c',M_max.*c_inf,h2,'m')
legend('V_{min1}','V_{max1}','V_{stall}','V_{min2}','V_{max2}')
xlabel('Velocities (m/s)')
ylabel('Altitude h (km)')
ylim([0 12.7])

%% Task 4

figure(2)
plot(M_min,h2,'r',M_max,h2,'b')
hold on;
plot(Mach_min,h2,'c',Mach_max,h2,'m')
legend('M_{min2}','M_{max2}','M_{min1}','M_{max1}')
xlabel('Mach numbers')
ylabel('Altitude h (km)')
ylim([0 12.2])

%% Task 5

[Max_v,i_m]=max(V_max);
h(i_m)
[Max_M,i_n]=max(Mach_max);
h(i_n)
%% Task 6

V1=(2./rho_inf*(K/CD0)^(1/2)*W_S).^(1/2);
V1_2=(2./rho_inf*(3*K/CD0)^(1/2)*W_S).^(1/2);
V3_2=(2./rho_inf*(K/(3*CD0))^(1/2)*W_S).^(1/2);

M1=V1./c_inf;
M1_2=V1_2./c_inf;
M3_2=V3_2./c_inf;

figure(3)
plot(V_min,h2,'r',V_max,h2,'b',M_min.*c_inf,h2,M_max.*c_inf,h2,V_stall,h2,'k',V1,h2,'m',V1_2,h2,'g',V3_2,h2,'c')
legend('V_{min1}','V_{max1}','V_{min2}','V_{max2}','V_{stall}','V_1','V_{1/2}','V_{3/2}')
xlabel('Velocities (m/s)')
ylabel('Altitude h (m)')
ylim([0 12.2])

figure(4)
plot(M_min,h2,'r',M_max,h2,'b',M1,h2,'m',M1_2,h2,'g',M3_2,h2,'c',V_stall./c_inf,h2,'k',Mach_min,h2,Mach_max,h2)
legend('M_{min2}','M_{max2}','M_1','M_{1/2}','M_{3/2}','M_{stall}','M_{min1}','M_{max1}')
xlabel('Mach numbers')
ylabel('Altitude h (m)')
ylim([0 12.2])

FID = fopen('Task1.tex', 'w');
fprintf(FID, '\\begin{tabular}{|ccccccc|} \\hline \n');
fprintf(FID, 'h (km) & $V_{1} (m/s)$ & $M_{1}$ & $V_{1/2} (m/s)$ & $M_{1/2}$ & $V_{3/2} (m/s)$ & $M_{3/2}$ \\\\ \\hline \n');
for k=1:length(h)
    fprintf(FID, '%8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f & %8.2f \\\\ ', h(k)/1000, V1(k),V1(k)/c_inf(k),...
        V1_2(k),V1_2(k)/c_inf(k), V3_2(k),V3_2(k)/c_inf(k));
    if k==length(h)
        fprintf(FID, '\\hline ');
    end
    fprintf(FID, '\n');
end
 
fprintf(FID, '\\end{tabular}\n');
fclose(FID);

%% Task 7

q100=(1/2)*rhossl.*V_max.^2;

V_80=((2./rho_inf)*0.8.*q100).^(1/2);


figure(5)
plot(V_min,h2,V_max,h2,M_min.*c_inf,h2,M_max.*c_inf,h2,V_stall,h2,V_80,h2)
legend('V_{min1}','V_{max1}','V_{min2}','V_{max2}','V_{stall}','V_{80}')
xlabel('Velocities (m/s)')
ylabel('Altitude h (km)')
ylim([0 12.2])


%% Task 8

% h1=[0:2e3:6e3];
% [P_1, rho_1, T_1, c_1]=atm_parameters(h1,T_tropo,h_tropo,...
%     Tssl,Pssl,rhossl);
% 
% TA_W1=TA_W_SL*rho_1/rhossl;
% 
% % V_min=(1./(CD0*rho_1)*W_S.*(TA_W1-sqrt(TA_W1.^2-4*K*CD0))).^(1/2);
% % V_max=(1./(CD0*rho_1)*W_S.*(TA_W1+sqrt(TA_W1.^2-4*K*CD0))).^(1/2);
% % V_stall=(W_S*2./(rho_1*CL_max)).^(1/2);
% 
% 
% step_v=(V_max(1)-V_min(1))/1000;    
% V_inf1=[V_min(1):step_v:V_max(1)];
% RC1=V_inf1.*(TA_W1(1)-CD0*rho_1(1)*V_inf1.^2/(2*W_S)-K*W_S*2./(rho_1(1)*V_inf1.^2));
% 
% step_v=(V_max(2)-V_min(2))/1000;    
% V_inf2=[V_min(2):step_v:V_max(2)];
% RC2=V_inf2.*(TA_W1(2)-CD0*rho_1(2)*V_inf2.^2/(2*W_S)-K*W_S*2./(rho_1(2)*V_inf2.^2));
% 
% step_v=(V_max(3)-V_min(3))/1000;    
% V_inf3=[V_min(3):step_v:V_max(3)];
% RC3=V_inf3.*(TA_W1(3)-CD0*rho_1(3)*V_inf3.^2/(2*W_S)-K*W_S*2./(rho_1(3)*V_inf3.^2));
% 
% step_v=(V_max(4)-V_min(4))/1000;    
% V_inf4=[V_min(4):step_v:V_max(4)];
% RC4=V_inf4.*(TA_W1(4)-CD0*rho_1(4)*V_inf4.^2/(2*W_S)-K*W_S*2./(rho_1(4)*V_inf4.^2));
% 
% plot(V_inf1,RC1,'b',V_inf2,RC2,'r',V_inf3,RC3,'c',V_inf4,RC4,'k')
% hold on;
% line([V_stall(1) V_stall(1)],[0 16])
% line([V_stall(2) V_stall(2)],[0 16])
% line([V_stall(3) V_stall(3)],[0 16])
% line([V_stall(4) V_stall(4)],[0 16])
% legend('0 km','2 km','4 km','6 km','V_{stall,0}','V_{stall,2}','V_{stall,4}','V_{stall,6}')
% xlabel('Velocity (m/s)')
% ylabel('Rate of climb (m/s)')
% ylim([0 16])

%% Task 9

Z=1+(1+3*4*CD0*K./TA_W.^2).^(1/2);

V_RC_max=(TA_W.*W_S.*Z./(3*rho_inf*CD0)).^(1/2);
RCmax=(W_S*Z./(3*rho_inf*CD0)).^(1/2).*TA_W.^(3/2).*(1-Z/6-3*4*CD0*K./(2*TA_W.^2.*Z));
Mach_RC_max=V_RC_max./c_inf;

Vthetamax=(2./rho_inf*W_S*(K/CD0)^(1/2)).^(1/2);
% theta_max=asin(TA_W-CD0*(1/2)*rho_inf.*Vthetamax.^2/W_S-K*W_S*2./(rho_inf.*Vthetamax.^2));
theta_max=asin(TA_W-sqrt(4*CD0*K));

figure(9)
plot(V_min,h2,V_max,h2,V_stall,h2,V_RC_max,h2)
legend('V_{min1}','V_{max1}','V_{stall}','V_{RC,max}')
xlabel('Velocities (m/s)')
ylabel('Altitude (km)')
ylim([0 12.2])

figure(10)
plot(Mach_min,h2,Mach_max,h2,V_stall./c_inf,h2,'k',Mach_RC_max,h2)
legend('M_{min1}','M_{max1}','M_{stall}','M_{RC,max}')
xlabel('Mach numbers')
ylabel('Altitude h (km)')
ylim([0 12.2])


theta_max=theta_max*180/pi;

figure(11)
plot(theta_max,h,'b')
xlabel('\theta_{max}')
ylabel('Altitude (m)')


FID = fopen('Task1.tex', 'w');
fprintf(FID, '\\begin{tabular}{|ccccc|} \\hline \n');
fprintf(FID, 'h (km) & $RC_{max} (m/s)$ & $V_{RC,max} (m/s)$ & $theta_{max} $ & V_{theta,max} $ \\\\ \\hline \n');
for k=1:length(h)
    fprintf(FID, '%8.2f & %8.2f & %8.2f & %8.2f & %8.2f \\\\ ', h2(k), RCmax(k),V_RC_max(k),...
        theta_max(k),Vthetamax(k));
    if k==length(h)
        fprintf(FID, '\\hline ');
    end
    fprintf(FID, '\n');
end
 
fprintf(FID, '\\end{tabular}\n');
fclose(FID);


%% Task 10
% 
figure(11)
plot(RCmax,h2,'b')
xlabel('RC_{max} (m/s)')
ylabel('Altitude (km)')
ylim([0 13])
line([0 0],[0 13])
% t_cl1=integral(@time_climb,0,5e3);
% t_cl2=integral(@time_climb,5e3,10e3);


t_5=trapz(h(1:51),1./RCmax(1:51));

t_10=trapz(h(51:101),1./RCmax(51:101));


%service ceiling
[aa,i_service]=min(abs(RCmax-0.51));
%Absolute ceiling
[abab,i_ceil2]=min(abs(RCmax));







