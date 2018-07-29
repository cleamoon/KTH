function out = resize(in)
global ne;
out = max(min(in, ne), 0);