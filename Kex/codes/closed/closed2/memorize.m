function memorize()
global t States pos tend;
t = t+1;
if t <= tend
    States(:,t) = [pos(1,1), pos(1,2), pos(2,1), pos(2,2), ...
        pos(3,1), pos(3,2), pos(4,1), pos(4,2)];
end
