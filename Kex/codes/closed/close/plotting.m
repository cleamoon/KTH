function plotting()
global S ne bl bn t
hold on;
axis([0 ne 0 ne]);
axis square;
axis on;
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
plot(S(1, 1:t), S(2, 1:t), 'r-');
plot(S(3, 1:t), S(4, 1:t), 'g-');
plot(S(5, 1:t), S(6, 1:t), 'b-');
plot(S(7, 1:t), S(8, 1:t), 'm.');