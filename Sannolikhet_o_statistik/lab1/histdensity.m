function hist_density(y, mz)
% HIST_DENSITY(Y) Plots a normalized histogram of the data Y.

% The area for each individual bar is height*width. Since MATLAB will 
% choose equidistant points for the bars, so the width is:
% delta_x = x(2) - x(1);
% Now if we sum up all the individual bars the total area will come out as
% A=sum(f)*delta_x;
% So the correctly scaled plot is obtained by
% if length(y) < 2000
%     [f,x] = hist(y);
% elseif length(y) < 2000
%     [f,x] = hist(y, 50);
% else
if ~exist('mz', 'var'), mz = 100; end
    [f,x] = hist(y, mz);
% end

bar(x, f/sum(f)/(x(2)-x(1)))

end
