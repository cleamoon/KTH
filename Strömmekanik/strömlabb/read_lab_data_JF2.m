%   read_lab_data_JF2 reads the experimental data files in the FPG LAB.
%   The function takes as argument the "file_name" and the number of bad 
%   experimental data points "nr_bad" close to the wall.
%
%   Note that the file name has to be given as a text string.
%   Example:
%           file_name = 'fpg_x23_gr1'
%
%
%     [Y, U] = read_lab_data_JF2(file_name, nr_bad)
%
%
%    
%=================================================================
function [C1_use, C2_use] = read_lab_data_JF2(file_name, nr_bad)

eval(['load ' num2str(file_name) '.txt'])
eval(['C1 = ' num2str(file_name) '(:,2) ;'])
eval(['C2 = ' num2str(file_name) '(:,3) ;'])

C2_use = C2(nr_bad+1:end) ;
C1_use = C1(nr_bad+1:end) ;

[P, S] = polyfit(C2_use(1:3), C1_use(1:3), 1) ;
UP = [0 12] ;
YP = polyval(P, UP) ;

figure(1), clf
plot(UP, YP, 'm-', 'linewidth', 2), hold on
plot(C2, C1, 'ko', 'markersize', 8), hold on
plot(C2_use, C1_use, 'ko', 'markersize', 8, 'markerfacecolor', 'b'), hold on
xlabel('Uy  (m/s)','fontsize', 16), ylabel('Y  (mm)','fontsize', 16)
set(gca, 'fontsize', 16)

