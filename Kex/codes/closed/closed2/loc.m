function res = loc(in) 
global ne;
res = min(max(floor(in)+1, 1), ne);