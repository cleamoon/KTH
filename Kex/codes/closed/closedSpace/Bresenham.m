function Bresenham (x0, y0, x1, y1, c)
global M Mobsp Mobse ne;
steep = abs(y1 - y0) > abs(x1 - x0);
if steep == true
	tmp = x0;
    x0 = y0;
    y0 = tmp;
	tmp = x1;
    x1 = y1;
    y1 = tmp;
end
reverse = x0 > x1;
if reverse
	tmp = x0;
    x0 = x1;
    x1 = tmp;
	tmp = y0;
    y0 = y1;
    y1 = tmp;
end
deltax = x1 - x0;
deltay = abs(y1 - y0);
error = 0;
deltaerr = deltay / deltax;
y = y0;
if y0 < y1 
    ystep = 1;
else
    ystep = -1;
end
l = zeros(ne*2, 2);
nn = 1;
for x = x0:1:x1
    if steep == true
        l(nn, :) = [y, x];
    else
        l(nn, :) = [x, y];
    end
    nn = nn+1;
    error = error + deltaerr;
    if error >= 0.5 
        y = y + ystep;
        error = error - 1.0;
    end
    if (y<1) || (y>ne)
        break;
    end
end
if reverse == false
    for i = 1:nn-1
%         i
%         l(i,1)
%         l(i,2)
%         M(l(i,1), l(i,2))
        if M(l(i,1), l(i,2)) == 1
            return;
        else
            if c == 1
                Mobsp(l(i,1), l(i,2)) = 1;
            else
                Mobse(l(i,1), l(i,2)) = 1;
            end
        end
    end
else
    for i = nn-1:-1:1
%         disp('nn is ')
% %         nn 
%         disp('diff is ')
%         x1 - x0
%         disp('y is ')
%         l(i,2)
        if M(l(i,1), l(i,2)) == 1
            return;
        else
            if c == 1
                Mobsp(l(i,1), l(i,2)) = 1;
            else
                Mobse(l(i,1), l(i,2)) = 1;
            end
        end
    end
end