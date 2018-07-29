function initialization()
% Initial positions and initial velocities [x, y, v, phi]
% Global variables
global nh nm nr S dt tm te N rt D LS R vm a omegam alpha calculated_time s;
global fd perm_opti theta_opti decided;
% Number of humans.
nh = 4; 
% Number of mouses;
nm = 1;
% Number of all runners.
nr = nh+nm; 
% Degree of freedom of moving.
fd = 5;
% Initial states where the first column is initial state of the mouse. 
S = [
    0       0       3       pi      0; 
    10      0       0       0       0; 
    8       6       1       0       0; 
    -2      12      4       pi/2    0; 
    10      15      4       pi/4    1;
    ]'; 
% Time step
dt = 0.01;
% Maximum simulation time
tm = 100;
% Ending time of the simulation, default equal with tm
te = tm;
% Maximum simulation steps
N = tm/dt;
% Reaction time for each runner.
rt = [0.1 0.1 0.1 0.1 0.1]';
rt = rt/5;
% Decision matrix that containing the desired velocity and angle that each 
% runner want to archive.
D = zeros(2, nr);
% Matrix that contains situation of each step
LS = zeros(fd*nr, N);
memorize(1);
% Radius of the target surranding circle
R = 2;
% Maximum velocity of the runners 
vm = [3 4 4 4 4];
% Longitudinal acceleration of the runners
a = [6 5 5 5 5];
% Maximum angular acceleration of the runnes
omegam = [21 8 8 8 8];
% Angular acceleration of the runners
alpha = [550 30 30 30 30];
% alpha = [0.5 0.3 0.3 0.3 0.3];
% Saved calculated time to optimize the simulation
decided = false;
calculated_time = -1;
perm_opti = 1:nh;
theta_opti = 0;
% Parameter s used in the virtual vehicle approach
s = zeros(1, nr);
end