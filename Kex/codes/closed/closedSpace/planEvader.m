function planEvader()
global ne pp We ue exy;
% Mv = zeros(3, 1);
% ue = zeros(3, 2);
% Cv = zeros(3, 2);
% for i = 1:ne
%     for j = 1:ne
%         D = zeros(3, 1);
%         for k = 1:3
%             D(k) = dis(pp(k, 1), pp(k, 2), i, j);
%         end
%         [~, k] = min(D);
%         Mv(k) = Mv(k) + We(i, j);
%         Cv(k, 1) = Cv(k, 1) + We(i, j)*i;
%         Cv(k, 2) = Cv(k, 2) + We(i, j)*j;
%     end
% end
% for i = 1:3
%     Cv(i, :) = Cv(i, :)/Mv(i);
%     ue(i, :) = -k*[i-Cv(i, 1), j-Cv(i, 2)];
% end

%% if the mouse do not move.
ue = [0, 0];

% %% 8 direction's trivial algorithm
% l = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];
% n = 8;
% lw = zeros(n,1);
% for i = 1:n
%     lw(i) = We(loc(exy(1)+l(i, 1)), loc(exy(2)+l(i, 2)));
% end
% [~, dir] = min(lw);
% % dir
% ue(:) = l(dir, :);
