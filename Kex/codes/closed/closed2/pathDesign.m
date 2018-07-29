function pathDesign()
global dp ds pos nn ne;
for k = 1:nn+1
    
    q = dp(k,:);
    r = small2big(pos(k,:));
    [~, ~, p, ~, ~, ~, ~] = findRegion(q);
    np = ne;
    l1 = (q - r)/np;
    l2 = (q + [0.1,0.1]*np - r)/np;
    for i = 1:np
        if norm (p - q) > ne*0.05
            pp = l1*i+r;
        else
            pp = l2*i+r;
        end
        if max(pp) > ne || min(pp) < 0 
            break;
        end
        ds(k, i, :) = big2small(pp); 
    end
end