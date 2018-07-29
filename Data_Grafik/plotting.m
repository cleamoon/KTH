data = textread('res.txt');
data = [0; data; 0];
x = (0:1:1001)/(1001);
u = sin(pi*x);
figure();
hold on
plot(x, data, 'r');
plot(x, u, 'b');
legend('Numerical result', 'Analytical result', 'Location', 'South')
title('Computed and anlytical solution')
xlabel('x coordinate')
ylabel('y coordinate')
axis([0 1 0 1])
figure();
plot(x, abs(u'-data), 'r');
legend('Error', 'Location', 'South')
title('Error of the numerical computation')
xlabel('x coordinate')
ylabel('Error')
axis([0 1])
