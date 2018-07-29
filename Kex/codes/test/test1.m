v_mus = 3.7; %[m/s]
v_man = 4;   %[m/s]
a_mus = 6;   %[m/s²]
a_man = 5;   %[m/s²]
alpha_mus = 567; %[rad/s²]
alpha_man = 8^2 * 0.5;%(omega_man² * r_arm) [rad/s²] 
omega_mus = 21; %[rad/s]
omega_man = 8; %[rad/s]
r_mus = 0.5;
x_mus = 0;
y_mus = 0;
x_man1 = 15;
y_man1 = 0;

mus_v_vek = linspace(0,v_mus);
man_v_vek = linspace(0,v_man);

mus_angle_vek = linspace(0,2*pi);
man_angle_vek = linspace(0,2*pi);

dx_man = man_v_vek.*cos(man_angle_vek);                 % Create ‘x’ Coordinate
dy_man = man_v_vek.*sin(man_angle_vek);                 % Create ‘y’ Coordinate

dx_mus = mus_v_vek.*cos(mus_angle_vek);
dy_mus = mus_v_vek.*sin(mus_angle_vek);

gradx_man = gradient(dx_man);               % Create x-Direction Vector
grady_man = gradient(dy_man);               % Create y-Direction Vector

gradx_mus = gradient(dx_mus);
grady_mus = gradient(dy_mus);

figure(1)
hold on
quiver(dx_man, dy_man, gradx_man, grady_man)
grid

quiver(dx_mus, dy_mus, gradx_mus, grady_mus)
grid

%x_man2 = 13
%y_man2 = 2

