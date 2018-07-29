function [ k ] = CalcK(h0, h1, t0, t1, u)
%CalcK Calculate k values
%   note water level in container (h0)
%   Plugg outlet and measure time dt until 
%   water level reaches h1
%   u voltage
%   gamma 
A = 15.52;

k = A .* (h1 - h0)./(u.*(t1-t0));
variance = var(k)
k = mean(k);
end

