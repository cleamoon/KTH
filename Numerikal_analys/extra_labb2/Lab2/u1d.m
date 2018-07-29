load ('eiffel1.mat');

m = size(xnod);
N = m(1);

% utan lu
begin = cputime;
max_bel = -Inf;
min_bel = Inf;
max_j = 1;
min_j = 1;

for j = 1 : N
    clearvars b x xbel ybel;
    b=zeros(2*N,1);
    b(j*2)=-1;
    x = A\b;
    abs_bel = norm(x);
    if abs_bel > max_bel
        max_bel = abs_bel;
        max_j = j;
    end
    if abs_bel < min_bel
        min_bel = abs_bel;
        min_j = j;
    end
end
gauss_time = cputime - begin

clearvars b x;

% med lu
begin = cputime;
max_bel = -Inf;
min_bel = Inf;
max_j = 1;
min_j = 1;

[L,U]=lu(A);

for j = 1 : N
    clearvars b x xbel ybel;
    b=zeros(2*N,1);
    b(j*2)=-1;
    x=U\(L\b); 
    abs_bel = norm(x);
    if abs_bel > max_bel
        max_bel = abs_bel;
        max_j = j;
    end
    if abs_bel < min_bel
        min_bel = abs_bel;
        min_j = j;
    end
end
lu_time = cputime - begin

