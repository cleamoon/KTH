load('eiffel1.mat')
[V, E] = eig(A);
e = diag(E);
[e, p] = sort(e);

n = 4;

eMin = e(1:n)
pMin = p(1:n);

vMin = [];

for i = 1:n
    figure
    trussplot(xnod,ynod,bars);
    hold on;
    xbel = xnod + 2*V(1:2:end, pMin(i)); ybel = ynod + 2*V(2:2:end, pMin(i));
    trussplot(xbel,ybel,bars);
    hold on;
    
    text(-2, 3, sprintf('Frekvens: %.5f', sqrt(eMin(i))/(2*pi)));
    
    %figure
    %trussanim(xbel,ybel,bars, 2*V(:, pMin(i)))
end