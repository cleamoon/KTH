figure()
hold on;
grid on;
plot(ry.time, Theta.signals.values(:,1), 'r.-')
plot(ry.time, Theta.signals.values(:,2), 'g.-')
plot(ry.time, Theta.signals.values(:,3), 'b.-')
xlabel('Time')
ylabel('Radius')
title('Plot of system against time')
legend('\theta_1', '\theta_2', '\theta_3', 'Location', 'East')
figure()
hold on;
grid on;
plot(ry.time, Schedule.signals.values(:,1), 'r.-')
plot(ry.time, Schedule.signals.values(:,2), 'g.-')
plot(ry.time, Schedule.signals.values(:,3), 'b.-')
xlabel('Time')
ylabel('Schedule')
title('Plot of schedule against time')
legend('Controller_1', 'Controller_2', 'Controller_3', 'Location', 'East')
