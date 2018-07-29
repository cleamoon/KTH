function res = towSquare(x, y, i, j, phi)
res = true;
if     towEdge(x, y, i-1, j-1, i  , j-1, phi)
    return;
elseif towEdge(x, y, i-1, j-1, i-1, j  , phi)
    return;
elseif towEdge(x, y, i  , j-1, i  , j , phi)
    return;
elseif towEdge(x, y, i-1, j  , i  , j  , phi)
    return;
else
    res = false;
end