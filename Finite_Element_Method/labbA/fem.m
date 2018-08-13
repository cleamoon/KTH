function res = fem(faii, faij, fbi, f, h, fint)
N = round(1/h)-1;
A = zeros(N);
b = zeros(N, 1);
for i=1:N
    A(i,i) = faii(h, i);
    for j=i-1:i+1
        if j>0 && j<=N
            if i ~= j
                A(i,j) = faij(h, i, j);
            end
        end
    end
    b(i) = fbi(f, h, fint, i);
end
res = A\b;
