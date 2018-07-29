%   read_lab_data_JF3 reads the experimental data files in the FPG LAB.
%   
%   Note that the file name has to be given as a text string.
%   Example:
%           file_name = 'fpg_xman'
%
%
%     [X, h] = read_lab_data_JF(file_name)
%
%    
%=================================================================
function [C1, C2] = read_lab_data_JF3(file_name)

eval(['load ' num2str(file_name) '.txt'])
eval(['C1 = ' num2str(file_name) '(1:end-1,2) ;'])
eval(['C2 = ' num2str(file_name) '(:,3) ;'])