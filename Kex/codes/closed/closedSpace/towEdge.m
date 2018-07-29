function res = towEdge(x, y, x1, y1, x2, y2, phi)
phi1 = atan2(y1-y, x1-x);
phi2 = atan2(y2-y, x2-x);
if (phi1-phi)*(phi2-phi) < 0
    res = true;
else
    res = false;
end
