function dt_cl=time_climb(dh)

global W_S CD0 K rhossl TA_W_SL Tssl Pssl T_tropo h_tropo

[P_inf, rho_inf, T_inf, c_inf]=atm_parameters(dh,T_tropo,h_tropo,...
    Tssl,Pssl,rhossl);

TA_W=TA_W_SL*rho_inf/rhossl;
Z=1+(1+3*4*CD0*K./TA_W.^2).^(1/2);

RC=(W_S*Z./(3*rho_inf*CD0)).^(1/2).*TA_W.^(3/2).*(1-Z/6-3*4*CD0*K./(2*TA_W.^2.*Z));

dt_cl=dh./RC;

end