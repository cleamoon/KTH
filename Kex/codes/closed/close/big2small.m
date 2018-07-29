function res = big2small(q)
[ll, ru, p, x0, y0, x1, y1] = findRegion(q);
d = q - p;
% phi = atan(d(2)/d(1));
a = norm(distance2rectangle(q, p, ll, ru)-p);
b = norm(distance2rectangle(q, p, [x0, y0], [x1, y1])-p)-a;
% if norm(d) > 1e-12
% if norm(p-q) > ne*0.1;
    res = (a + norm(d)*b/(a+b))*d/norm(d) + p;
% else
% %     q
% %     [min(q(1)+0.1*ne, ne), min(q(2)+0.1*ne, ne)]
%     res = big2small([min(q(1)+vp/3, ne), min(q(2)+vp/3, ne)]);
% end
% else
%     Mv = 0;
%     Cv = [0,0];
%     for i = ll(1):ru(1)
%         for j = ll(2):ru(2)
%             Mv = Mv + Wp(i, j);
%             Cv = Cv + Wp(i, j)*[i, j];
%         end
%     end
%     % q(:)
%     % size(Cv(:)/Mv)
%     res = big2small(Cv(:)'/Mv);
% end