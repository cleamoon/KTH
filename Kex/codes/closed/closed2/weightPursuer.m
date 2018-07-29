function weightPursuer ()
global Wp ne nn tlost Mobs pos lost elast ft;
if ft || ~lost
    for i = 1:ne
        for j = 1:ne
            td = zeros(nn, 1);
            for k = 1:nn
                td(k) = norm(pos(k,:)-[i, j]);
            end
            d = min(td);
            % sigma = (1/t)^0.1;
            sigma = tlost^0.1;
            Wp(i,j) = 1-exp(-d^2/2/sigma)/sqrt(2*pi*sigma)+0.001;
            if ~Mobs(i, j)
                Wp(i, j) = Wp(i, j)*tlost^0.1;
            else 
                Wp(i, j) = Wp(i, j)/tlost^0.1;
            end
        end
     end
else
    for i = 1:ne
        for j = 1:ne
            d = norm(elast-[i,j]);
            % sigma = (1/t)^0.1;
            sigma = 1;
            Wp(i,j) = exp(-d/2/sigma)/sqrt(2*pi*sigma)+0.001;
%             if ~Mobs(i, j)
%                 Wp(i, j) = Wp(i, j)*tlost^0.1;
%             else 
%                 Wp(i, j) = Wp(i, j)/tlost^0.1;
%             end
        end
    end
end