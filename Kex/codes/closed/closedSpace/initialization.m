function initialization()
global M Mobsp Mobse Wp We ne vp ve r n xyp xye tend S up;
ne = 20; % number of elements on each edge of the map
M = zeros(ne, ne); % the map where '0' means path and '1' means obstacle
Mobsp = zeros(ne, ne); % the observable map in the pursuers' perspective
Mobse = zeros(ne, ne); % the observable map in the evader's perspective
Wp = zeros(ne, ne); % the weighted map in the pursuers' view
We = zeros(ne, ne); % the weighted map in the evader's view
% Initialization of the map with obstacle
M(ne*0.1:ne*0.4, ne*0.3:ne*0.6) = 1;
M(ne*0.7:ne*0.9, ne*0.1:ne*0.2) = 1;
M(ne*0.2:ne*0.5, ne*0.8:ne*0.9) = 1;
M(ne*0.6:ne*0.9, ne*0.4:ne*0.5) = 1;
M(ne*0.6:ne*0.8, ne*0.5:ne*0.6) = 1;
M(ne*0.6:ne*0.7, ne*0.6:ne*0.7) = 1;
prop = 10;
vp = 5/prop; % velocity of the pursuers
ve = 4/prop; % velocity of the evader
r = ne/50; % the sight length of the pursuers
n = 3; % number of pursuers
% initial position of pursuers
xyp = [ne*0.1-1, ne*0.2; ne*0.6-1, ne*0.5; ne*0.2-1, ne*0.9];
pp = xyp;
xye = [ne*0.8, ne*0.7];
exy = xye;
tend = 1000;
S = zeros((3+1)*2, tend+1);
S(:,1) = [pp(1,1), pp(1,2), pp(2,1), pp(2,2), pp(3,1) pp(3,2), exy(1), exy(2)];
up = zeros(3, 2); % velocities of the pursuers