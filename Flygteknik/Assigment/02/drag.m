function cd = drag(alpha, a0, cl_max) 
    %% indatas
    cd0 = 0.0092;
    k = 0.0141;
    alpha = abs(alpha);
    %% formulars
    if alpha < cl_max/a0 
        cd = cd0 + k*(a0*alpha)^2;
    else
        cd = cd0 + k*cl_max^2 + 2.5*k*cl_max*(a0*alpha-cl_max);
    end
end
