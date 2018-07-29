function res = isBlocked(x1, y1, x2, y2)
global M ne;
phi = atan2(y2-y1, x2-x1);
res = false;
for i = 1:ne
    for j = 1:ne
        if M(i,j) == 1
             if towSquare(x2, y2, i, j, phi)
                 res = true;
                 return;
             end
        end
    end         
end