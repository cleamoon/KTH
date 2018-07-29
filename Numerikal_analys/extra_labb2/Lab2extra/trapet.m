function [out] = trapet(f, a, b, tol):
    out = 1;
    l = size(a);
    if (l ~= size(b))
        return 0;
    for i = 1:l
        for j = a(i):tol:b(i)
            inte = (tol)*(f(j)+f(j+tol))/2;
            return (inte*trapet(f, a(i+1:l), b(i+1:l), tol));
        end
    end    
    
        
 