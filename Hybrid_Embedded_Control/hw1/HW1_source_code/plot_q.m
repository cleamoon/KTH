load('arm_state.mat')
figure()
hold on;
grid on;
plot(x.Time, x.Data(:,1), 'r.-')
plot(x.Time, x.Data(:,2), 'b.-')
xlabel('Time')
ylabel('Radius')
title('Plot of system against time')
legend('q1', 'q2', 'Location', 'East')