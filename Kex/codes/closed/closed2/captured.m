function out = captured()
global pos nn;
for i = 1:nn
    if  norm( pos(i,:)-pos(nn+1, :)) < 1
        out = true;
        return;
    end
end
out = false;