function [ J ] = JacobianM(U, Uold, hz, n)
R=0.05;  
nu=10^-5;
hr=R/n;
J=zeros(2*n,2*n);

for i=2:n-1
  J(i, i-1) = -nu/hr^2 + nu/2/hr^2/(i-1) - U(n+i)/2/hr;
  J(i, i) = 2*nu/hr^2 + (U(i)-Uold(i))/hz + U(i)/hz;
  J(i, i+1) = -nu/hr^2 - nu/2/hr^2/(i-1) + U(n+i)/2/hr;
  J(i, n+1) = 1;
  J(i, n+i) = (U(i+1)-U(i-1))/2/hr;
  J(i+n, i) = 1/hz;
  if i ~= 2
    J(i+n, n+i-1) = -1/2/hr;
  end
  J(i+n, n+i) = 1/hr/(i-1);
  J(i+n, n+i+1) = 1/2/hr;
end

J(1, 1) = (U(1)-Uold(1))/hz + U(1)/hz + 4*nu/hr^2;
J(1, 2) = -4*nu/hr^2;
J(1, n+1) = 1;
J(n, n-1) = -nu/hr^2 + nu/2/hr^2/(n-1) - U(2*n)/2/hr;
J(n, n) = 2*nu/hr^2 + (U(n)-Uold(n))/hz + U(n)/hz;
J(n, n+1) = 1;
J(n, 2*n) = (-U(n-1))/2/hr;
J(2*n, n) = 1/hz;
J(2*n, 2*n-1) = -1/2/hr;
J(2*n, 2*n) = 1/hr/(n-1);

% First order
J(n+1, 1) = 1/hz;
J(n+1, n+2) = 2/hr;
% Second order 
