function [z] = geome_to_geopot ( h )
    % This function convert geometric height to geopotential height
    % With the earth radius from ISA
    r = ISA.r_g; 
    z = (r*h/(r-h));
return