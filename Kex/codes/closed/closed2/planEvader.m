function planEvader()
global We ne dp r pos Mobs nn;
% %% 8 direction's trivial algorithm
% l = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];
% n = 8;
% lw = zeros(n,1);
% for i = 1:n
%     lw(i) = We(loc(pos(nn+1, 1)+l(i, 1)), loc(pos(nn+1, 2)+l(i, 2)));
% end
% [~, dir] = max(lw);
% ue(:) = l(dir, :);
Mk = 0;
C = [0,0];
for i = 1:ne
    for j = 1:ne
        xy = loc(big2small([i,j]));
        if norm(loc(pos(4,:)-xy)) < r*0.5
            Mk = Mk + We(xy(1), xy(2));
            C = C + We(xy(1), xy(2))*[i, j];
        end
    end
end
c = C/Mk;
dp(4, :) = c;
% lhide = [1 1; 1 ne-1; ne-1 1; ne-1 ne-1; 0.1*ne-1 0.5*ne; 0.5*ne 0.5*ne; ...
%     0.9*ne 0.5*ne; 0.2*ne 0.7*ne; 0.8*ne 0.1*ne-1; 0.1*ne 0.1*ne];
% nh = max(size(lhide));
% tt = [];
% d = [];
% for i = 1:nh
%     p = (lhide(i, :));
%     if ~Mobs(p(1), p(2))
%         tt = [tt lhide(i, :)'];
%         d = [d norm(small2big(pos(nn+1, :))-small2big(lhide(i, :)))];
%     end
% end
% % tt
% % d
% [~, j] = min(d);
% % j
% % tt(:, j)
% if ~isempty(tt)
%     dp(nn+1, :) = (tt(:, j));
% else
%     dp(nn+1, :) = [1, 1];
% end