function b = beta(r, R, alpha_ideal, J_base) 
    % the blade angle distribution function beta(r)
    b = alpha_ideal + phi_r(r, R, J_base);
end
