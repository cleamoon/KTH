function [h] = geopot_to_geome ( z = 0 )
    % This function convert geometric height to geopotential height
    % With the earth radius from ISA
    r = ISA.r_g; 
    h = r*z/(r+z);
returngeo