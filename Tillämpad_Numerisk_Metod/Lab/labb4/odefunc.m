function [ f ] = odefunc( t,u,N )
%Function to be used in Ode23
A=[];
h=0.1;
for i = 2:N-1
A(i,i)=-2;
A(i,i+1)=1;
A(i,i-1)=1;
end

A(1,2)=1;
A(1,1)=-2;
A(N,N)=-2;
A(N,N-1)=2;

A=1/h^2*sparse(A);

b=zeros(1,N)';

if t> 1
    func = 0;
else
    func = 1;
end 

b(1)=func/h^2;


f = A*u+b;

end

