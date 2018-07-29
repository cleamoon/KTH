function chase()
global pos dp nn;
for i = 1:3
    angle = pi*2*(i-1)/3;
    dp(i, :) = pos(nn+1, :) + [cos(angle), sin(angle)]/2; % radius = 1/2
end
