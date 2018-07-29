function [M_inf]=newton_raph(M0,P_inf,rho_inf,eps,Niter)

global CD0 gamma K W_S rhossl TA_W_SL

M_inf=M0;
dif=1;

for j1=1:Niter
    if dif>eps
    TA_max=(1/2)*CD0*gamma*P_inf*M_inf^2*(1/W_S)+K*W_S/((1/2)*gamma*P_inf*M_inf^2); %Ratio Thrust/weight
    sigma=rho_inf/rhossl; %Density ratio

    B=TA_max/TA_W_SL - 0.76*(0.907+0.262*(abs(M_inf-0.5))^(1.5))*sigma^(0.7);
    
        if M_inf>=0.5
        B_prime=(1/TA_W_SL)*(CD0*gamma*P_inf*(1/W_S)*M_inf - 4*K*W_S/(gamma*P_inf*M_inf^3))...
            - 0.76*0.262*1.5*(M_inf-0.5)^0.5*sigma^(0.7);
        else 
             B_prime=(1/TA_W_SL)*(CD0*gamma*P_inf*(1/W_S)*M_inf - 4*K*W_S/(gamma*P_inf*M_inf^3))...
            - 0.76*0.262*1.5*(0.5-M_inf)^0.5*sigma^(0.7);
        end
    
    M0=M_inf; %Value at (n-1)th iteration
    M_inf=M_inf-B/B_prime; %Value at nth iteration
    dif=abs(M_inf-M0);
    else break;
    end 
end

end
