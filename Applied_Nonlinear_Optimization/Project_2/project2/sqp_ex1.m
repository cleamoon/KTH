clear variables
close all


x=[-5 -3].';
l_out=[1 1].'; 
mu=1;
s=mu./l_out;

i=1;
[f,gradf,g,A,HessL] = script_ex54(x(:,1),l_out(:,1));
err=norm([g; gradf-A.'*l_out(:,i)]);
while err>1e-6


H=HessL;
c=gradf;
b=-g;
l_in=[1 1].';
mu=1;
p=[0 0].';

%x = quadprog(H,c,-A,-b)

[p,s(:,i+1),l_out(:,i+1)] = qp_algorithm(A,b,c,H,p,l_in,mu);
x(:, i+1)=x(:,i)+p;

i=i+1;
[f,gradf,g,A,HessL] = script_ex54(x(:,i),l_out(:,i));

err=norm([ gradf-A.'*l_out(:,i)]);
if g<0
    err = err + 1000*norm(g);
end
end

