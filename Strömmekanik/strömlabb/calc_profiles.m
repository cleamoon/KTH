function [delta_star_expe, delta_star_teore, H, f, fp, fpp, fppp, eta, b, Uy, Ue, theta, delta, Y, ny] = calc_profiles(in, dr, nu)
% Experimental profiles
str = strcat('Gr12_',num2str(in));
[Y, Uy] = read_lab_data_JF2(str, dr);                        % Read the data
x=in/100;
[Ywall, ny] = FPG_LAB_JF_P1(Y, Uy);                         % Get wall-position Ywall and the acceleration parameter ny
Y = Y - Ywall;                                              % Correct the Y1 with the wall position
Uys = sort(Uy);
Ue = (Uys(end) + Uys(end-1) + Uys(end-2))/3;                   % Get the velocity in the free stream
delta_star_expe = trapz(Y/1000, (ones(size(Uy))-Uy/Ue));    % Get the displacement thickness
theta = trapz(Y/1000, Uy/Ue.*(ones(size(Uy))-Uy/Ue));       % Get the momentum thickness

% teoretical profile
[f, fp, fpp, fppp, eta] = FS_solver_JF(ny);
b = eta(end) - f(end);
delta = (nu*x/Ue)^(1/2);
delta_star_teore = delta*b;
H = delta_star_teore/theta;                                  % Get the shape factor
