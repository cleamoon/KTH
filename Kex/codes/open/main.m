%% Initialize
initialization();
global nm nr dt tm te rt LS fd R;


%% Simulation
for t = 0:dt:tm % Time elapse
    
    % Decide the running path
    for i = 1:nr
        if mod(t, rt(i)) == 0 % Time to react for runner $i
            if (i <= nm) % 
                omegad = desired_eva_dummy(i);
                % omegad = desired_eva(i, t);
                path_determ_eva(omegad, i);
            else
                pd = desired_pur(i, t);
                path_determ_pur(pd, i);
            end
        end
    end
    
    % Running.
    run();
    memorize(round(t/dt+2));
    
    % check if the evader is captured.
    if check()
        te = t;
        disp('Final time: ');
        disp(te)
        break;
    end
    if t == tm
        disp('Not captured');
    end
end
    
%% Result plotting
% ending step
ns = te/dt;
figure();
hold on;
axis equal;
for j = 1:nr
    x = LS((j-1)*fd+1, 1:ns);
    y = LS((j-1)*fd+2, 1:ns);
    u = LS((j-1)*fd+3, 1:ns).*cos(LS((j-1)*fd+4, 1:ns));
    v = LS((j-1)*fd+3, 1:ns).*sin(LS((j-1)*fd+4, 1:ns));
%         if j<=nm
%             plot(x + R*cos(2*pi/100*(1:100)), y + R*sin(2*pi/100*(1:100)), 'r:');
%         else
%             quiver(x, y, u, v, 'bo');
%         end
    if j<=nm
        quiver(x, y, u, v, 'r-.');
        plot(x(end)+R*cos(2*pi/100*(1:100)), y(end)+R*sin(2*pi/100*(1:100)), 'g--');
    else
        % plot(x, y, 'b');
        quiver(x, y, u, v, 'b--');
    end
end
legend('Evader','Capturing circle','Pursuer', 'Location', 'southeast');
grid on;