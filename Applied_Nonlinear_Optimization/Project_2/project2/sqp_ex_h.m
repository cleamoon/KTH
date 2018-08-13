clear variables
close all


x=zeros(9,1);
l_out=ones(24,1); 
mu=1;
s=mu./l_out;

i=1;
[f,gradf,g,A,HessL] = hexagon(x(:,1),l_out(:,1));
err=norm([g; gradf-A.'*l_out(:,i)]);
while err>1e-6


H=HessL;
c=gradf;
b=-g;
l_in=ones(24,1);
mu=1;
p=zeros(9,1);

%x = quadprog(H,c,-A,-b)

[p,s(:,i+1),l_out(:,i+1)] = qp_algorithm(A,b,c,H,p,l_in,mu);
x(:, i+1)=x(:,i)+p;

i=i+1;
[f,gradf,g,A,HessL] = hexagon(x(:,i),l_out(:,i));

err=norm([gradf-A.'*l_out(:,i)]);
end
