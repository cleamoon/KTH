%% The driver function
%% Initialization
global t tend tlost pos nn elast lost;
initialization();

%% Simulatioin
find = false;
lost = true;
while ~captured() && t<tend
    setObservableRegion(1);
    if ~find && observing()
        disp('find time: ' + t);
        find = true;
%         tlost = 0;
%     else
%         if lost
%             elast = pos(nn+1, :);
%         end
%         find = false;
%         tlost = tlost + 1;
    end
    pursuit();
    evade();
    run();
    memorize();
end

%% Plot
plotting();
