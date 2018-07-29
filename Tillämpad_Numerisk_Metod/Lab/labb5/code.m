hv = [0.2 0.1];
Nv = [19, 39];
Mv = [11, 21];

for l = 1:2
  h = hv(l);
  N = Nv(l);
  M = Mv(l);
  S = M*N;
  A = zeros(S);
  b = zeros(S, 1);
  for i = 1:N
      for j = 2:M-1
          k = i + N*(j-1);
          A()
          A(k,k) = 4;