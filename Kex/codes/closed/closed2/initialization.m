function initialization()
global M Mobs Wp We ne vmax r t tend States pos bl bn nn dp ds regions obstacles tlost elast ft;
ne = 30; % number of elements on each edge of the map
nn = 3; % number of pursuers
M = zeros(ne, ne); % the map where '0' means path and '1' means obstacle
Mobs = zeros(ne, ne); % the observable map 
Wp = zeros(ne, ne); % the weighted map in the pursuers' view
We = zeros(ne, ne); % the weighted map in the evader's view
% Initialization of the map with obstacle
M(ne*0.1:ne*0.4, ne*0.3:ne*0.6) = 1;
M(ne*0.7:ne*0.9, ne*0.1:ne*0.2) = 1;
M(ne*0.2:ne*0.5, ne*0.8:ne*0.9) = 1;
M(ne*0.6:ne*0.8, ne*0.4:ne*0.6) = 1;
prop = 10;
vmax = [5, 5, 5, 4]/prop; % maximum velocity of the runners
r = 0.5*ne; % the sight length of the pursuers
% initial position of the pursuers and the evader
pos = [ 0.05,    0.20; ... 
        0.05,    0.50; ...
        0.15,    0.90; ...
        0.89,    0.70] *ne;
% time
t = 1;
tend = 5000;
% matrix that memorize the states of the positions of all runner
States = zeros((3+1)*2, tend+1);
States(:,1) = [pos(1,1), pos(1,2), pos(2,1), pos(2,2), pos(3,1) pos(3,2), pos(4,1), pos(4,2)];
% obstacles
bn = [0, 4, 8, 12, 16];
bl = [ ...
    1 3; 4 3; 4 6; 1 6; ...
    2 8; 5 8; 5 9; 2 9; ...
    6 4; 8 4; 8 6; 6 6; ...
    7 1; 9 1; 9 2; 7 2] *ne/10;
regions = [ ...
    0       0       5.5     7.5; ...
    0       7.5     10      10; ...
    5.5     3       10      7.5; ...
    5.5     0       10      3] * ne/10;
obstacles = [ ...
    1 3 4 6; ...
    2 8 5 9; ...
    6 4 8 6; ...
    7 1 9 2]*ne/10;
% desired points
dp = zeros(nn+1, 2);
% desired path
ds = zeros(nn+1, ne, 2);
tlost = 1;
elast = zeros(2,1);
ft = true;