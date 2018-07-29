function weightEvader ()
global t We ne Mobs pos nn;
setObservableRegion(2);
for i = 1:ne
    for j = 1:ne
        de = norm(pos(nn+1,:)-[i,j]);
        td = zeros(3,1);
        for k = 1:3
            td(k) = norm(pos(k,:)-[i,j]);
        end
        [d, ~] = min(td);
        if ~Mobs(i, j)
            sigma = (2)^0.1/3;
        else
            sigma = (2)^0.1;
        end
        % We(i,j) = exp(((de+1)/(d+1))^0.1/2/sigma)/sqrt(2*pi*sigma)+.2;
        We(i,j) = (exp(-(d)^2/2/sigma)/sqrt(2*pi*sigma))+0.001;
    end
end
% xy = loc(pos(4,:));
% if Mobs(xy(1), xy(2))
%     for i = 1:ne
%         for j = 1:ne
%             de = norm(pos(4,:)-[i,j]);
%             % We(i,j) = We(i,j) - exp(-de^0.1/2/sigma)/sqrt(2*pi*sigma)+.1;
%             We(i, j) = 0.01;
%         end
%     end
% end