function plotting()
global States ne bl bn t
hold on;
axis([0 ne 0 ne]);
axis square;
axis on;
plot(States(1, 1:t), States(2, 1:t), 'r.');
plot(States(3, 1:t), States(4, 1:t), 'g.');
plot(States(5, 1:t), States(6, 1:t), 'b.');
plot(States(7, 1:t), States(8, 1:t), 'm--');
legend('Pursuer 1', 'Pursuer 2', 'Pursuer 3', 'Evader');
l = max(size(bn));
for i = 1:l-1
    d = bn(i+1) - bn(i);
    x = zeros(1, d);
    y = zeros(1, d);
    for j = 1:(bn(i+1)-bn(i))
        x(j) = bl(j+bn(i), 1);
        y(j) = bl(j+bn(i), 2);
    end
    fill(x, y, 'k')
end