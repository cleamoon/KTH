% chisquare_fit_template.m
% ------------------------------------------------------------------------
% Script to to a chi-square fit to data, with errors
% on both x and y. 
% 
% Author: Edvin Sidebo, Victor Mikhalev, 2015-04-02
%         Based heavily on wnonlinfit.m written 
%         by Jannick Weisshaupt (at the time of writing available at 
%           http://www.mathworks.com/matlabcentral/fileexchange/35565-weighted-nonlinear-curve-fit-script-with-plotter/)
%		  and on ploterr.m written by Felix Zoergiebel (at the time of writing available at http://www.mathworks.com/matlabcentral/fileexchange/22216-ploterr)
%
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------


clf;

% First some helper functions
% that will become useful later

% Approximate derivative with central difference
% for function which should be defined on the form
% f(x, parameters_array)
getDerivative = @(x, dx, func, params) (func(x+dx,params)-func(x-dx,params))/(2*dx); 

% Get total error on y if you have both y (intrinsic) error and x error
% Again for a function defined on the form f(x, parameters_array)
getTotalError = @(xerr,yerr,x,dx,func, params) sqrt(yerr.^2 + (getDerivative(x, dx, func, params).*xerr).^2);


% ------------------------------------------------------------------------
% Now do the data analysis
% 
% % X AND Y DATA
% % Here make sure you import the data so that 
% % your x and y values go into xData and yData
% xData = ...
% yData = ...
% 
% % ERRORS ON X AND Y DATA
% % Define the errors on y (and x, if present)
% error_yData_intrinsic = ...     % Uncertainty on y
% error_xData = ... % Uncertainty on x


% MODEL FUNCTION TO FIT TO DATA
% Define the function you want to fit here, on
% on the form f(x, parameters_array)
fitfunc=@(x,params) params(1)*exp(-x/params(2)*log(2))+params(3)*exp(-x/params(4)*log(2))+params(5); % Example: A*exp(-x)*sin(B*x)

% PARAMETER STARTING GUESS
% Starting guess for parameters
% Note that the length of the array must match 
% the number of parameters as defined in @fitfunc
params0 = [30, 20,10,140,3];

% AXIS AND LEGEND OPTIONS
% Labels and options (in LaTeX format)
legendposition=[];                      % Legend position [left, bottom, width, height]
legendText={'XXX' 'YYY'};        % Legend text: 1st entry: data, 2nd: fit
mylabel={'x axis title','y axis title'}; % Axis titles



% PERFORM THE ACTUAL FIT:
%   If there are errors on x, we need to iterate many times
%   since the total errors depend on the parameters. 
%   Set nIter accordingly
nIter = 1;
params = params0; % parameter array, at first equal to starting guess
dx = 0.001;     % step to use in calculating derivative
for i = 1:nIter
    % Calculate the total y error based on the current parameters
    error_total = getTotalError(error_xData, error_yData_intrinsic, xData, dx, fitfunc, params);
    
    % If not last iteration: don't make plot
    if i ~= nIter
        [beta betaerr chi prob chiminvec]=wnonlinfit(xData,yData,error_xData,error_yData_intrinsic, error_total,fitfunc,params0...
            ,'chitol', 4, 'plot', 'off'); % Small chitol = try harder to find minimum of chi-square (more iterations)
    % Else if last iteration: make plot
    else
        [beta betaerr chi prob chiminvec]=wnonlinfit(xData,yData,error_xData,error_yData_intrinsic, error_total,fitfunc,params0...
            ,'chitol',2,'label',mylabel,'position',legendposition,...
            'legendText',legendText);
        fprintf('Reduced chi^2=%f\n',chi);
        fprintf('H_0 probability=%f\n',prob);
    end
    params = beta; % Update parameters
    
end

% DISPLAY RESULTS OF FIT
fprintf('Best-fit values of parameters, with uncertainties:\n');
for i=1:length(params)
    fprintf('\tParameter %d: %f +/- %f \n', i, params(i), betaerr(i));
end

% PRINT FIGURE AS PDF
 print -dpdf -cmyk test.pdf









