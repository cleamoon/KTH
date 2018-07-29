function ret = hat(x, y, xi, yi, h, N)
if x < 0 || y < 0 || x > 1 || y > 1
    ret = 0;
    return;
elseif x < xi-h || y < yi-h || x > xi+h || y > yi+h
    ret = 0;
    return;
end
if x < xi
    if y < yi
        if xi-x > y+h-yi
            ret = 0;
        else
            ret = 1-(xi-x)./h-(yi-y)./h;
        end
    else
        if xi-x > y-yi
            ret = 1-(xi-x)./h;
        else 
            ret = 1-(y-yi)./h;
        end
    end
else
    if y < yi
        if h+xi-x > y+h-yi
            ret = 1-(yi-y)./h;
        else
            ret = 1-(x-xi)./h;
        end
    else
        if h+xi-x > y-yi
            ret = 1-(x-xi)./h-(y-yi)./h;
        else 
            ret = 0;
        end
    end
end
end