function planPursuer()
global ne pp Wp up r M;
%% Coverage control without non-convex considering
% Mv = zeros(3, 1);
% up = zeros(3, 2);
% Cv = zeros(3, 2);
% for i = 1:ne
%     for j = 1:ne
%         D = zeros(3, 1);
%         for k = 1:3
%             D(k) = dis(pp(k, 1), pp(k, 2), i, j);
%         end
%         [~, k] = min(D);
%         Mv(k) = Mv(k) + Wp(i, j);
%         Cv(k, 1) = Cv(k, 1) + Wp(i, j)*i;
%         Cv(k, 2) = Cv(k, 2) + Wp(i, j)*j;
%     end
% end
% kprop = 1;
% for i = 1:3
%     Cv(i, :) = Cv(i, :)/Mv(i);
%     up(i, :) = -kprop*[pp(i, 1)-Cv(i, 1), pp(i, 2)-Cv(i, 2)];
% end

%% 8 direction's trivial algorithm
% l = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];
% n = 8;
% lw = zeros(n,1);
% for k = 1:3
%     for i = 1:n
%         lw(i) = Wp(loc(pp(k, 1)+l(i, 1)), loc(pp(k, 2)+l(i, 2)));
%     end
%     [~, dir] = max(lw);
%     % dir
%     up(k, :) = l(dir, :);
% end

%% trivial algorithm with more detailed angle
% l = 1:360;
% n = 360;
% lw = zeros(n,1);
% for k = 1:3
%     for i = 1:n
%         lw(i) = Wp(loc(pp(k, 1)+r*cosd(l(i))), loc(pp(k, 2)+r*sind(l(i))));
%     end
%     [~, dir] = max(lw);
%     % dir
%     up(k, :) = [cosd(l(dir)), sind(l(dir))];
% end

%% Coverage control
Mv = zeros(3, 1);
Mvv = zeros(3, 1);
Mvh = zeros(3, 1);
up = zeros(3, 2);
Cv = zeros(3, 2);
Cvv = zeros(3, 2);
Cvh = zeros(3, 2);
p = [0.2, 0.4]*ne;
ll = [0.1, 0.3]*ne - [1,1];
ru = [0.4, 0.6]*ne;
%p = (ll+ru)/2;
for i = 1:ne
    for j = 1:ne
%         if M(i, j) ~= 1
            tranxy = loc(transformation([i, j], p, ll, ru));
            D = zeros(3, 1);
            for k = 1:3
                txy = trans(pp(k), p, ll, ru);
                %D(k) = dis(pp(k, 1), pp(k, 2), i, j)*Wp(loc(pp(k, 1)), loc(pp(k, 2)));
                ltxy = loc(txy);
                D(k) = dis(txy(1), txy(2), i, j)*Wp(ltxy(1), ltxy(2));
            end
            [~, k] = min(D);
            % loc(transformation([i, j], p, ll, ru))
            Mv(k) = Mv(k) + Wp(tranxy(1), tranxy(2));
            Cv(k, :) = Cv(k, :) + Wp(tranxy(1), tranxy(2))*[i, j];
%             if M(i, j) ~= 1
%                 Mvv(k) = Mvv(k) + Wp(i, j);
%                 Cvv(k, 1) = Cvv(k, 1) + Mvv(k)*i;
%             else
%                 Mvh(k) = Mvh(k) + Wp(i, j);
%                 Cvh(k, 2) = Cvh(k, 2) + Mvh(k)*j;
%             end
%         end
    end
end
kprop = 1;
for i = 1:3
%     Cv(i, :) = Cvv(i, :)*Mvv(i)/(Mvv(i)+Mvh(i)) + Cvh(i, :)*Mvv(i)/(Mvv(i)+Mvh(i));
%     up(i, :) = -kprop*[pp(i, 1)-Cvv(i, 1), pp(i, 2)-Cv(i, 2)];
    Cvt = transformation(Cv(i, :)/Mv(i), p, ll, ru);
    scatter(Cvt(1), Cvt(2));
    up(i, :) = -kprop*(pp(i, :)-Cvt);
end