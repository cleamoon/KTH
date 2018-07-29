function out = dire(in)
if norm(in) > 1e-8
    out = in/norm(in);
else
    out = [0,0];
end