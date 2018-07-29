function res = Qfunc(z, a, b, Q0)
if z < a
    res = 0;
else
    if z < b
        res = Q0*(sin((z-a)/(a-b)*pi));
    else
        res = 0;
    end
end