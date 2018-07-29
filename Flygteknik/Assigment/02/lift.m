function cl = lift(alpha, a0, cl_max, dcl, alpha_cr)
    if alpha < 0
        cl = - lift(-alpha, a0, cl_max, dcl, alpha_cr);
        return ;
    end
    if alpha < alpha_cr
        cl = cl_small(alpha, a0, cl_max);
    else
        cl = cl_large(alpha, a0, cl_max, dcl);
    end
end