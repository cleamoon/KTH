%% Initialization
redarc = [ 1 1 2 2 3 3 4 5 5 6 7 8; 2 3 4 5 5 6 7 7 8 8 9 9];
bluearc = [2 1 4 2 5 3 4 7 5 8 7 9; 1 3 2 5 3 6 7 5 8 6 9 8];
lr = size(redarc)*[0 1]';
lb = size(bluearc)*[0 1]';
l = 1+lr+lb;
A = zeros(l, 19);
for i = 1:lr
    in = redarc(1, i);
    out = redarc(2, i);
    A(1+i, 1+in) = 1;
    A(1+i, 1+out) = -1;
end
for i = 1:lb
    in = bluearc(1, i);
    out = bluearc(2, i);
    A(1+lr+i, 10+in) = 1;
    A(1+lr+i, 10+out) = -1;
end
A = A';
B = zeros(lr, l);
for i = 1:lr
    B(i, 1) = -1;
    B(i, 1+i) = 1;
    B(i, 1+i+lr) = 1;
end
n = zeros(19, 1);
a = 1908;
b = 1272;
n(2) = a;
n(10) = -a;
n(14) = b;
n(16) = -b;
n2 = zeros(lr, 1);
ld = zeros(l, 1);
ub = ones(l, 1)*inf;
ub2 = ones(l, 1)*inf;
ub2(11) = 0;
ub2(19) = 0;
f = zeros(l, 1);
f(1) = 1;

%% 1 
format long
s = linprog(f, B, n2, A, n, ld, ub);
fprintf('The optimal solution is %d\n', s(1));
fprintf('The setup is the following: \n')
for i = 1:lr
    fprintf('The red flow from the node %d to the node %d is: %d\n', redarc(1, i), redarc(2, i), round(s(1+i)));
end
for i = 1:lr
    fprintf('The blue flow from the node %d to the node %d is: %d\n', bluearc(1, i), bluearc(2, i), round(s(1+lr+i)));
end

%% 2 
format long
s = linprog(f, B, n2, A, n, ld, ub2);
fprintf('The optimal solution now is %d\n', s(1));
fprintf('The setup is the following: \n')
for i = 1:lr
    fprintf('The red flow from the node %d to the node %d is: %d\n', redarc(1, i), redarc(2, i), round(s(1+i)));
end
for i = 1:lr
    fprintf('The blue flow from the node %d to the node %d is: %d\n', bluearc(1, i), bluearc(2, i), round(s(1+lr+i)));
end