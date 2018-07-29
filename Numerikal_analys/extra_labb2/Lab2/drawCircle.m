function drawCircle(x, y, r, color)
	if nargin < 4
        color = 'r';
	end
    hold on;
    ang=0:0.01:2*pi; 
    xp=r*cos(ang);
    yp=r*sin(ang);
    plot(x+xp,y+yp, color);
end