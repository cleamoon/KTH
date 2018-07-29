function [P_inf, rho_inf, T_inf, c_inf]=atm_parameters(h,T_tropo,h_tropo,Tssl,Pssl,rhossl)

R=287.0529; %Gas constant (normalised with air) (J/kg/K)
g0=9.81; 
gamma=1.4;

for i2=1:length(h)
    if h(i2)<=h_tropo
    a(i2)=(T_tropo-Tssl)/h_tropo;
    elseif h(i2)>=20e3
        a(i2)=1e-3;
    end
end

P0=Pssl;
T0=Tssl;
rho0=rhossl;

j=1;
while (h(j)<=h_tropo) && (j<length(h))
    T(j)=T0+a(j)*h(j);
    P(j)=P0*(T(j)/T0)^(-g0/(a(j)*R));
    rho(j)=rho0*(T(j)/T0)^(-(g0/(a(j)*R)+1));
    c(j)=sqrt(gamma*R*T(j));
    j=j+1;
end

P0=P(j-1);
rho0=rho(j-1);
h0=h(j-1);
T0=T_tropo;

while j<=length(h)
    T(j)=T0; %Temperature in Kelvin
    P(j)=P0*exp(-g0*(h(j)-h0)/(R*T0));
    rho(j)=rho0*exp(-g0*(h(j)-h0)/(R*T0));
    c(j)=sqrt(gamma*R*T(j));
    j=j+1;
end

% atm_ISA=[P',rho',T',c'];
% 
% P_inf=atm_ISA(:,1);
% rho_inf=atm_ISA(:,2);
% T_inf=atm_ISA(:,3);
% c_inf=atm_ISA(:,4);

P_inf=P;
rho_inf=rho;
T_inf=T;
c_inf=c;

end



