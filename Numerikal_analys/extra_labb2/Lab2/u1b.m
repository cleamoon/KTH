count = 20;

time = zeros([4,1]);
sizeN = zeros([4,1]);
for t = 1:4 
    clearvars A b bars begin i j m N x xnod ynod;
    switch t
        case 1 
            load ('eiffel1.mat');
        case 2
            load ('eiffel2.mat');
        case 3
            load ('eiffel3.mat');
        case 4
            load ('eiffel4.mat');
    end
    m = size(xnod);
    N = m(1);
    sizeN(t) = N;
    j = zeros([count,1]);
    for i = 1 : count
        j(i) = randi (N);
    end
    b=zeros(2*N,1);
    begin = cputime;
    for i = 1 : count
        b(j(i)*2-1)=1;
        x = A\b;
    end
    time(t) = cputime - begin;
end
loglog(sizeN, time);