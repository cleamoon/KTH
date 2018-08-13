function ret = hatp(x, y, xi, yi, h, N)
if x < 0 || y < 0 || x > 1 || y > 1
    ret = [0 0];
elseif x < xi-h || y < yi-h || x > xi+h || y > yi+h
    ret = [0 0];
elseif x < xi
    if y < yi
        if xi-x > y+h-yi
            ret = [0 0];
        else
            ret = [1/h 1/h];
        end
    else
        if xi-x > y-yi
            ret = [1/h 0];
        else 
            ret = [0 -1/h];
        end
    end
else
    if y < yi
        if h+xi-x > y+h-yi
            ret = [0 1/h];
        else
            ret = [-1/h 0];
        end
    else
        if h+xi-x > y-yi
            ret = [-1/h -1/h];
        else 
            ret = [0 0];
        end
    end
end
end
