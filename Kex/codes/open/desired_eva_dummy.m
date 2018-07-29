function omegad = desired_eva_dummy(i)
% dummy decision making for mouse, random walk
global omegam;
omegad = 2*(rand-0.5)*omegam(i);
end
