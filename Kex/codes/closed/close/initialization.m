function initialization()
global M Mobsp Mobse Wp We ne vp ve r tend xyp xye S up bl bn region regionobs;
ne = 30; % number of elements on each edge of the map
M = zeros(ne, ne); % the map where '0' means path and '1' means obstacle
Mobsp = zeros(ne, ne); % the observable map in the pursuers' perspective
Mobse = zeros(ne, ne); % the observable map in the evader's perspective
Wp = zeros(ne, ne); % the weighted map in the pursuers' view
We = zeros(ne, ne); % the weighted map in the evader's view
% Initialization of the map with obstacle
M(ne*0.1:ne*0.4, ne*0.3:ne*0.6) = 1;
M(ne*0.7:ne*0.9, ne*0.1:ne*0.2) = 1;
M(ne*0.2:ne*0.5, ne*0.8:ne*0.9) = 1;
M(ne*0.6:ne*0.8, ne*0.4:ne*0.6) = 1;
prop = 50;
vp = 5/prop; % velocity of the pursuers
ve = 6/prop; % velocity of the evader
r = 0.4*ne; % the sight length of the pursuers
% initial position of the pursuers
xyp = [ne*0.05-ne*0.05, ne*0.2; ne*0.05, ne*0.5; ne*0.15, ne*0.9];
% initial position of the evader
xye = [ne*0.8, ne*0.7];
tend = 1000;
S = zeros((3+1)*2, tend+1);
S(:,1) = [xyp(1,1), xyp(1,2), xyp(2,1), xyp(2,2), xyp(3,1) xyp(3,2), xye(1), xye(2)];
up = zeros(3, 2); % velocities of the pursuers
bn = [0, 4, 8, 12, 16];
bl = [1 3; 4 3; 4 6; 1 6; 2 8; 5 8; 5 9; 2 9; 6 4; 8 4; ...
    8 6; 6 6; 7 1; 9 1; 9 2; 7 2]*ne/10;
region = [0 0 5.5 7.5; 0 7.5 10 10; 5.5 3 10 7.5; 5.5 0 10 3]*ne/10;
regionobs = [1 3 4 6; 2 8 5 9; 6 4 8 6; 7 1 9 2]*ne/10;
