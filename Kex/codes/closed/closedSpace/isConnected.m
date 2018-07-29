function res = isConnected(x1, y1, x2, y2, c) 
global Mobsp Mobse ne;
if c == 1
    Mobs = Mobsp;
else
    Mobs = Mobse;
end
list = zeros(ne*ne, 2);
list(1, :) = [x1, y1];
n = 1;
res = false;
visited = zeros(ne, ne);
visited(x1, y1) = 1;
while list(1, 1) ~= 0
    p = list(n, 1);
    q = list(n ,2);
    visited(p, q) = 1;
    list(n, :) = [0, 0];
    if (p == x2) && (q == y2)
        res = true; 
    end
    if (p>1) && visited(p-1, q) ~= 1 && (Mobs(p-1, q) == 0)
        list(n, :) = [p-1, q];
        n = n+1;
    end    
    if (q>1) && ~visited(p, q-1) ~= 1 && (Mobs(p, q-1) == 0)
        list(n, :) = [p, q-1];
        n = n+1;
    end    
    if (p<ne) && ~visited(p+1, q) ~= 1 && (Mobs(p+1, q) == 0)
        list(n, :) = [p+1, q];
        n = n+1;
    end
    if (q<ne) && ~visited(p, q+1) ~= 1 && (Mobs(p, q+1) == 0)
        list(n, :) = [p, q+1];
        n = n+1;
    end
    n = n-1;
end
