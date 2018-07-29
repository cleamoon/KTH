function res = areaUnobs(x, y, c)
global Mobsp Mobse ne;
if c == 1
    Mobs = Mobsp;
else
    Mobs = Mobse;
end
list = zeros(ne*ne, 2);
list(1, :) = [x, y];
n = 1;
res = 1;
visited = zeros(ne, ne);
visited(x, y) = 1;
while n == 0
    p = list(n, 1);
    q = list(n ,2);
    list(n, :) = [0, 0];
    res = res + 1;
    visited(p, q) = 1;
    if (p>1) && visited(p-1, q) ~= 1 && (Mobs(p-1, q) == 0)
        list(n, :) = [p-1, q];
        n = n+1;
    end    
    if (q>1) && visited(p, q-1) ~= 1 && (Mobs(p, q-1) == 0)
        list(n, :) = [p, q-1];
        n = n+1;
    end    
    if (p<ne) && visited(p+1, q) ~= 1 && (Mobs(p+1, q) == 0)
        list(n, :) = [p+1, q];
        n = n+1;
    end
    if (q<ne) && visited(p, q+1) ~= 1 && (Mobs(p, q+1) == 0)
        list(n, :) = [p, q+1];
        n = n+1;
    end
    n = n-1;
end
