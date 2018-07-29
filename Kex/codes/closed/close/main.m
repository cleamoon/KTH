%% The driver function
%% Initialization
global M r Mobsp Mobse ne t xyp xye up ue vp ve tend regionobs;
initialization();
hold on;
%% Simulatioin
for t = 1:tend
    if observing()
        chase();
    else
        search();
    end
    evade();
    run();
    for i = 1:3
    for j = 1:4
        [x0, y0, x1, y1] = deal(regionobs(j, 1), regionobs(j, 2), regionobs(j, 3), regionobs(j, 4));
        if xyp(i, 1) >= x0 && xyp(i, 1) <= x1 && xyp(i, 2) >= y0 && xyp(i, 2) <= y1
            disp((xyp(i, :)));
            disp(t)
        end
    end
    end
    if capture()
        break;
    end
end

%% Plot
plotting();
