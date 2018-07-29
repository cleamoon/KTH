function cl = cl_small(alpha, a0, cl_max)
    %% indata 
    dalpha = 1;
    alpha = abs(alpha);
    %% formular
    n1 = 1 + cl_max/(a0*dalpha);
    cl = a0*alpha - a0*dalpha*(a0*alpha/(cl_max+a0*dalpha))^(n1);
end
