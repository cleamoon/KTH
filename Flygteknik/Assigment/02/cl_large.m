function cl = cl_large(alpha, a0, cl_max, dcl) 
    alpha = abs(alpha);
    cl = cl_max - dcl + (a0*alpha - cl_max)/5;
end
