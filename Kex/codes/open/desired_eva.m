function omegad = desired_eva(i, t)
global omegam S nh nm;
[x0, y0, phi0] = deal(S(1,i), S(2,i), S(4,i));
xi = zeros(1, nh);
yi = zeros(1, nh);
di = zeros(1, nh);
for i=1:nh
    xi(i) = S(i+nm,1);
    yi(i) = S(i+nm,2);
    phii(i) = S(i+nm,4);
    di = sqrt((x0-xi(i))^2+(y0-yi(i))^2);
end
xc = sum(xi)/nh;
yc = sum(yi)/nh;
% omegad = (atan((y0-yc)/(x0-xc))+pi/2)/t;
% omegad = cos(10*log(t+0.01))/2; % complex
% omegad = 10/(t+0.01); % spiral
omegad = cos(t); % periodical
end