clear
clc
sysmp = minphase;
[A,B,C,D] = ssdata(sysmp);
s=tf('s');
[m,n]=size(A);
G=C*inv(s*eye(m)-A)*B+D;
G11=G(1,1);G21=G(2,1);G12=G(1,2);G22=G(2,2);
% figure,sigma(G)
% lambda=G.*(inv(G).');
% H_inf=norm(G,inf);
% s=0*1i;
% rga=evalfr(lambda,s);
% figure,step(G)
%% minimum phase
phi_m=pi/3;
omega_c=0.1;

Ge=G11; %transfer function
[~,p1]=bode(Ge,omega_c);
T1=tan(-pi/2+phi_m-p1*pi/180)/omega_c;
GL1=Ge*(1+1/(s*T1));
GL1=abs(evalfr(GL1,1i*omega_c));
K1=1/GL1;
F1=K1*(1+1/(s*T1)); % controller
% figure,bode(F1*Ge1)

Ge=G22; %transfer function
[~,p2]=bode(Ge,omega_c);
T2=tan(-pi/2+phi_m-p2*pi/180)/omega_c;
GL2=Ge*(1+1/(s*T2));
GL2=abs(evalfr(GL2,1i*omega_c));
K2=1/GL2;
F2=K2*(1+1/(s*T2)); % controller

F=[F1,0;0,F2];
%% sensitivity and robustness
sens=minreal(inv((eye(2)+G*F)));
comsens=minreal(sens*G*F);

figure,sigma(sens,comsens)
legend('S','T','location','southeast')