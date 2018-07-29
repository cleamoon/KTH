function catched = check()
global nh R S;
[x0, y0] = deal(S(1,1), S(2, 1));
phi = zeros(1,nh);
for i = 1:nh
   s = S(:, i+1);
   [xi, yi, phi(i)] = deal(S(1, i+1), S(2, i+1), S(4, i+1));
   phi(i) = mod(phi(i), 2*pi);
   if sqrt((xi-x0)^2 + (yi-y0)^2) > 1.05*R
       catched = false;
       return;
   end
end
phi = sort(phi);
for i = 1:nh-1
    if mod(phi(i+1)-phi(i), 2*pi) - 2*pi/nh > 1e-8
        catched = false;
        return;
    end
end
disp('Captured!')
catched = true;
end
