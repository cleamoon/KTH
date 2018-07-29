global S ne bl bn t vp
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
n = 1000;
q = [ne*0.7, ne*0.5];
for i = 1:n
    if norm (p-q) > ne*0.1
        p = ([ne*0.7, ne*0.5]*1.4-[1,1])*i/n+[1,1];
    else
        p = ([ne*0.7, ne*0.5]*1.4-[1,1])*i/n+[1,1]+[1,1]*vp*10;
    end
    pp = big2small(p);
    plot(pp(1), pp(2), '*');
    hold on;
end