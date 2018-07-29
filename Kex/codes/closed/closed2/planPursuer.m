function planPursuer()
global M ne pos Wp dp nn lost elast ft t reach;
Mk = zeros(3, 1);
C = zeros(3, 2);
reach = false;
if ~ft && lost 
    for k = 1:nn
        % norm(small2big(pos(k, :))-(elast))
        if norm(small2big(pos(k, :))-(elast)) < ne*0.3
            reach = true;
            break;
        end
    end
end
if ~ft && lost && ~reach
    for k = 1:nn
        dp(k, :) = (elast);
    end
else
    for i = 1:ne
        for j = 1:ne
    %         xy = loc(big2small([i,j]));
    %         D = zeros(3, 1);
    %         for k = 1:3
    %             D(k) = norm((pos(k, :))-[i,j]);
    %         end
    %         [~, k] = min(D);
    %         Mk(k) = Mk(k) + Wp(xy(1), xy(2));
    %         C(k,:) = C(k,:) + Wp(xy(1), xy(2))*[i, j];
    % disp('back here') 
            D = zeros(3, 1);
            for k = 1:3
                D(k) = norm((pos(k, :))-[i,j]);
            end
            [~, k] = min(D);
            if ~M(i, j)
                Mk(k) = Mk(k) + Wp(i, j);
                C(k, :) = C(k, :) + Wp(i, j)*[i, j];
            end
        end
    end
    for k = 1:nn
        c = C(k,:)/Mk(k);
        dp(k, :) = (c);
    end
end