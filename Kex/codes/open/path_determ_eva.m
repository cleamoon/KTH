function path_determ_eva(phid, i)
% Simply changes of direction is enough.
global vm D;
D(:, i) = [vm(i) phid];
end