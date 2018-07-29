function planPursuer()
global ne xyp Wp vp r M regionobs;
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
% Mv = zeros(3, 1);
% up = zeros(3, 2);
% Cv = zeros(3, 2);
% Cvv = zeros(3, 2);
% Mvv = zeros(3, 1);
% Cvh = zeros(3, 2);
% Mvh = zeros(3, 1);
% Mvt = zeros(3, 1);
% for i = 1:ne
%     for j = 1:ne
% %         if M(i, j) ~= 1
%             tranxy = loc(big2small([i, j]));
%             % tranxy = loc([i,j]);
%             D = zeros(3, 1);
%             for k = 1:3
%                 %D(k) = dis(pp(k, 1), pp(k, 2), i, j)*Wp(loc(pp(k, 1)), loc(pp(k, 2)));
%                 txy = loc(small2big(xyp(k, :)));
%                 D(k) = norm(txy-[i,j]);
%             end
%             [~, k] = min(D);
%             % loc(transformation([i, j], p, ll, ru))
%             Mv(k) = Mv(k) + Wp(tranxy(1), tranxy(2));
%             Mvt(k) = Mvt(k) + Wp(i, j);
%             Cv(k, :) = Cv(k, :) + Wp(tranxy(1), tranxy(2))*[i, j];
%             if M(i,j) == 1
%                 Mvh(k) = Mvh(k) + Wp(i, j);
%                 Cvh(k, :) = Cvh(k, :) + Wp(i, j)*[i, j];
%             else
%                 Mvv(k) = Mvv(k) + Wp(i, j);
%                 Cvv(k, :) = Cvv(k, :) + Wp(i, j)*[i, j];
%             end
% %             if M(i, j) ~= 1
% %                 Mvv(k) = Mvv(k) + Wp(i, j);
% %                 Cvv(k, 1) = Cvv(k, 1) + Mvv(k)*i;
% %             else
% %                 Mvh(k) = Mvh(k) + Wp(i, j);
% %                 Cvh(k, 2) = Cvh(k, 2) + Mvh(k)*j;
% %             end
% %         end
%     end
% end
% for k = 1:3
% %     Cv(i, :) = Cvv(i, :)*Mvv(i)/(Mvv(i)+Mvh(i)) + Cvh(i, :)*Mvv(i)/(Mvv(i)+Mvh(i));
% %     up(i, :) = -kprop*[pp(i, 1)-Cvv(i, 1), pp(i, 2)-Cv(i, 2)];
% % disp ('Cv')
% % i
% % Cv(i,:)
% % Mv(i)
%     Cvm = Cv(k, :)/Mv(k);
%     Dl = [norm(Cvm-[2.5 4.5]*ne/10); norm(Cvm-[3.5 8.5]*ne/10); norm(Cvm-[7 5]*ne/10); norm(Cvm-[8 1.5]*ne/10)];
%     if min(Dl) > 1e-8
%         Cvt = big2small(Cv(k, :)/Mv(k));
%         % Cvt = big2small(Cv(i, :)/Mv(i));
%         scatter(Cvt(1), Cvt(2), 'md')
%         hold on;
%     %    scatter(Cvt(1), Cvt(2));
%         % up(k, :) = -kprop*(xyp(k, :)-Cvt);
%            for j = 1:4
%                 [x0, y0, x1, y1] = deal(regionobs(j, 1), regionobs(j, 2), regionobs(j, 3), regionobs(j, 4));
%                 if Cvt(1) >= x0 && Cvt(1) <= x1 && Cvt(2) >= y0 && Cvt(2) <= y1
%                     disp(Cvt);
%                     disp('warningwarningwarningwarningwarningwarningwarningwarningwarning');
%                 end
%             end
%         velocityCalculator(Cvt, k);
%     else
%         Cv(k, :) = Mvv(k)/Mvt(k)*Cvv(k, :) + Mvh(k)/Mvt(k)*Cvh(k, :);
%         Cvt = big2small(Cv(k, :)/Mvt(k));
%         scatter(Cvt(1), Cvt(2), 'md')
%         hold on;
%     %    scatter(Cvt(1), Cvt(2));
%         % up(k, :) = -kprop*(xyp(k, :)-Cvt);
%         velocityCalculator(Cvt, k);
%     end
% end
Mk = zeros(3, 1);
C = zeros(3, 2);
for i = 1:ne
    for j = 1:ne
        xy = loc(big2small([i,j]));
        D = zeros(3, 1);
        for k = 1:3
            D(k) = norm(small2big(xyp(k, :))-[i,j]);
        end
        [~, k] = min(D);
        Mk(k) = Mk(k) + Wp(xy(1), xy(2));
        C(k,:) = C(k,:) + Wp(xy(1), xy(2))*[i, j];
    end
end
for k = 1:3
    c = C(k,:)/Mk(k);
    [~, ~, q, ~, ~, ~, ~] = findRegion(c);
    p = xyp(k, :);
    if acos(dot(q-p, c-p)/norm(q-p)*norm(c-p)) > pi/10 && norm(c-q) < ne*0.05
        velocityCalculator(big2small(c), k);
    else
        velocityCalculator(big2small(c-[1,1]*vp), k);
    end
end