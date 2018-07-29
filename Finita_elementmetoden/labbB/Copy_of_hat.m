function ret = hat(X, Y, xi, yi, h, N)
ret = zeros(1,length(X));
for i = 1:length(X)
    x = X(i);
    y = Y(i);
    
    if x < h || y < h || x > h*N || y > h*N
    ret(i) = 0;
    elseif x < xi
    if y < yi
        if xi-x > y+h-yi
            ret(i) = 0;
        else
            ret(i) = 1-(xi-x)./h-(yi-y)./h;
        end
    else
        if xi-x > y-yi
            ret(i) = 1-(xi-x)./h;
        else 
            ret(i) = 1-(y-yi)./h;
        end
    end
else
    if y < yi
        if h+xi-x > y+h-yi
            ret(i) = 1-(yi-y)./h;
        else
            ret(i) = 1-(x-xi)./h;
        end
    else
        if h+xi-x > y-yi
            ret(i) = 1-(x-xi)./h-(y-yi)./h;
        else 
            ret(i) = 0;
        end
    end
end
end