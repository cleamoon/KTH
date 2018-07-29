classdef ISA
 
    properties (Constant)
        r_g = 6.356766e6;  % mean value of earth radius, m
        k = 1.380622e-23;  % Boltzmann constant, N*m/K
        N_A = 6.022169e23;  % Avogadro constant, mol^-1
        rho_SSL = 1.225; % density of air, kg/m^3
        P_SSL = 1.013250e5; % standard sea-level atmospheric pressure, Pa
        T_SSL = 288.15; % standard sea-level temperature, K
        S = 110; % Sutherland constant, K
        mu_0 = 1.7894e-5; % viscosity
        R = (ISA.P_SSL/(ISA.rho_SSL*ISA.T_SSL)); % gas constant, N*m/(mol*K)
        g_0 = 9.80665; % sea-level value of the acceleration of gravity, m/s^2
        M_i = [28.0134, 31.9988, 39.948, 44.00995, 20.183, 4.0026, 83.80, 131.30, 16.04303, 2.01594]'; % Molecular weights of sea-level dry air
        F_i = [.78084, .209476, .00934, .000314, 0.00001818, .00000524, .00000114, .000000087, .00002, .0000005]'; % fractional-volume of sea-level dry air
        H_b = [0, 11, 20, 32, 47, 52, 61, 79, 90]'; % geopotential height of changed temperature gradient, km'
        L_Mb = [-6.5, 0.0, 1.0,atmosisa 2.8, 0, -2.0, -4.0, 0]'; % gradients of molecular scale temperature, K/km'
        beta = 1.458e6; % constant in the expression for dynamic viscosity, kg/(s*m*K^1/2)
        gamma = 1.400; % c_p / c_v
        sigma = 3.65e-10; % the mean collision diameter, m
    end
    
    methods
    end
    
end

