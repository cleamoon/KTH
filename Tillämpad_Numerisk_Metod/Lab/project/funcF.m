function [ f ] = funcF(U, Uold, hz, n)
R=0.05;  
nu=10^-5;         
hr=R/n;
f=zeros(2*n, 1);

for i=2:n-1
  f(i) = U(i)*(U(i)-Uold(i))/hz - nu*(U(i+1)-2*U(i)+U(i-1))/hr^2 - nu*(U(i+1)-U(i-1))/2/hr^2/(i-1) + U(i+n)*(U(i+1)-U(i-1))/2/hr + U(n+1);
  if i ~= 2
    f(i+n) = (U(i)-Uold(i))/hz + U(n+i)/hr/(i-1) + (U(n+i+1) - U(n+i-1))/2/hr;
  else
    f(2+n) = (U(2)-Uold(2))/hz + U(n+2)/hr + (U(n+3))/2/hr;
  end
end


f(n) = U(n)*(U(n)-Uold(n))/hz - nu*((-2*U(n)+U(n-1))/hr^2 + (-U(n-1))/2/hr^2/(n-1)) + U(2*n)*(-U(n-1))/2/hr + U(n+1);
f(2*n) = (U(n)-Uold(n))/hz + (- U(2*n-1))/2/hr + U(2*n)/hr/(n-1);
f(1) = U(1)*(U(1)-Uold(1))/hz - 4*nu*(U(2)-U(1))/hr^2 + U(n+1);
% First order
f(n+1) = (U(1)-Uold(1))/hz + 2*U(n+2)/hr;
% Second order 