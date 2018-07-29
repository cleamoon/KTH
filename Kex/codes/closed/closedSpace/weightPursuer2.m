function weightPursuer ()
global M Wp r ne exy t Mobsp;
for i = 1:ne
    for j = 1:ne
        if Mobsp(i, j) 
% setObservableRegion(r);
% xm = floor(exy(1))+1;
% ym = floor(exy(2))+1;
% if observing()
%     Wp = zeros(ne, ne);
%     for i = -ne:ne
%         for j = -ne:ne
%             x = i+xm;
%             y = j+ym;
%             if and(x>0, x<ne)
%                 if and(y>0, y<ne)
%                     Wp(x, y) = 1/exp(sqrt(i*i+j*j)/ne);
%                     if ~Mobsp(x, y)
%                         Wp(x, y) = Wp(x, y) * exp(t);
%                     end
%                 end
%             end
%         end
%     end
% else
%     for i = 1:ne
%         for j = 1:ne
%             min = ne+1;
%             for k = 1:3
%                 d = dis(i, j, xm, ym);
%                 if min > d
%                     min = d;
%                 end
%             end
%             d = min;
%             if ~Mobsp(i, j)
%                 if Mobsp(i, j)
%                     Wp(i, j) = d * 2;
%                 else
%                     Wp(i, j) = d * 1.5;
%                 end
%             else
%                 Wp(i, j) = d * 1;
%             end
%         end
%     end
% end
% xm = floor(exy(1))+1;
% ym = floor(exy(2))+1;
% for i = 1:ne
%     for j = 1:ne
%         d = dis(xm, ym, i, j);
%         Wp(i,j) = exp(-d^2/2/sqrt(1/t))/sqrt(2*pi*sqrt(1/t))+.1;
% %         if M(i, j) == 1 && i>1 && i<ne && j>1 && j<ne
% %             for p = -1:1
% %                 for q = -1:1
% %                     Wp(i+p, j+q) = Wp(i+p, j+q) - (1/sqrt(sqrt(p*p+q*q+1))+1);
% %                 end
% %             end
% %             Wp(i, j) = 0;
%     end
% end
