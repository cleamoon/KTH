%tol = 5*10^-6;
% fortfarande för långsamt för att köras.
tol = 5*10^-3;
omr = tol:tol:1.2;
summa = 0;
for a = omr
    for b = omr
        for c = omr
            for d = omr
                for e = omr 
                    for f = omr
                        for g = omr
                            for h = omr
                                for i = omr
                                    for j = omr
                                        % omvandla produkten till följande
                                        % formel. 
                                        summa = summa + tol^10/2^10*(exp(a*b*c*d*e*f*g*h*i*j))^10*(exp((a+tol)/a)+1)*(exp(b+tol)/b+1)*(exp(c+tol)/c+1)*(exp(d+tol)/d+1)*(exp(e+tol)/e+1)*(exp(f+tol)/f+1)*(exp(g+tol)/g+1)*(exp(h+tol)/h+1)*(exp(i+tol)/i+1)*(exp(j+tol)/j+1);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
summa
