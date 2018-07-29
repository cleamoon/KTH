function [EBOs, res, cos]=f(k, sx, EBOi, c, s_max, res, cos) 
% if not(exist(res, 1))
%     res=[];
%     cos=[];
% end
si = 4;

if k==si
    if sx<0
        EBOs = 0;
        res = [res EBOs];
        cos = [cos 0*c(k)];
        return;
    else
        %EBOi(2, int32(floor(sx/c(7)))+1);
        maxi = int32(floor(sx/c(si)));
        EBOs = EBOi(si, maxi+1);

    end
else
    EBOx = zeros(1,s_max);
    for xi=1:1:s_max
        [EBOs, res, cos] = f(k+1, sx-xi*c(k), EBOi, c, s_max, res, cos);
        EBOx(xi) = EBOi(k, xi) + EBOs;
    end
    [EBOs, maxi]= min(EBOx); 
    res = [res EBOs];
    cos = [cos maxi*c(k)];
end
%res = [res EBOs];