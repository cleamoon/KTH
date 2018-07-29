function weightEvader ()
global M We ne exy Mobse pp;
setObservableRegion(ne);
xm = floor(exy(1))+1;
ym = floor(exy(2))+1;
We = zeros(ne, ne);
for i = -ne:ne
    for j = -ne:ne
        x = i+xm;
        y = j+ym;
        if and(x>0, x<ne)
            if and(y>0, y<ne)
%                A = areaUnobs(x, y, 2);
                A = 1;
                ld = zeros(3,1);
                for k = 1:3
                    ld(k) = dis(loc(pp(k,1)), loc(pp(k,2)), x, y);
                end
                d = min(ld);
                if Mobse(x, y)
                    We(x, y) = exp(-d^2/2/(10))/sqrt(2*pi*(1/10))+.1;
                else
                    We(x, y) = (exp(-d^2/2/(100))/sqrt(2*pi*(1/100))+.1)/20;
                    
%                     if isConnected(x, y, xm, ym, 2)
%                         We(x, y) = exp(1/(sqrt(i*i+j*j)/1));
%                     else
%                         We(x, y) = exp(1/(sqrt(i*i+j*j)/2));
%                     end
                end
                if M(x, y) == 1
                    We(x, y) = 10;
                end
                for k = 1:ne
                    We(k, 1 ) = 10;
                    We(k, ne) = 10;
                    We(1, k ) = 10;
                    We(ne,k ) = 10;
                end
            end
        end
    end
end
