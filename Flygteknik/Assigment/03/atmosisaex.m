function [T, a, P, rho] = atmosisaex (h) 
    r_g = 6.356766e6;  % mean value of earth radius, m
    k = 1.380622e-23;  % Boltzmann constant, N*m/K
    N_A = 6.022169e23;  % Avogadro constant, mol^-1
    rho_SSL = 1.225; % density of air, kg/m^3
    P_SSL = 1.013250e5; % standard sea-level atmospheric pressure, Pa
    T_SSL = 288.15; % standard sea-level temperature, K
    S = 110; % Sutherland constant, K
    g_0 = 9.80665; % sea-level value of the acceleration of gravity, m/s^2
    R = (P_SSL/(rho_SSL*T_SSL)); % gas constant, N*m/(mol*K)
    lim = 20000;
    if h<=lim
        [T, a, P, rho] = atmoslapse(h, 9.80665, 1.4, 287.0531, 0.0065, 11000, 20000, 1.225, 101325, 288.15 );
        return ;
    else
        h = h - lim;
        r0 = r_g+lim;
        g0 = g_0*(r_g/r0)^2; 
        [T0, a0, P0, rho0] = atmoslapse(lim, 9.80665, 1.4, 287.0531, 0.0065, 11000, 20000, 1.225, 101325, 288.15 );
        lambda = 1.0/1000;
        T = T0 + lambda*h;
        g = g0*(r0/(r0+h))^2;
        a = sqrt(1.4*T*R);
        P = P0*(1+lambda*h/T0)^(-g/lambda/R);
        rho = rho0*(1+lambda*h/T0)^(-1-g/lambda/R);
        return ;
    end
end
