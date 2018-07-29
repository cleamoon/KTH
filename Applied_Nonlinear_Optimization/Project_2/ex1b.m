clear variables
close all

x=ones(9, 1);
l_out=ones(24,1);

mu=ones(24,1);

for i=1:20

    [f,gradf,g,A,HessL] = hexagon(x(:, i),l_out(:,i));

    p0=ones(9,1);
    l_in=ones(24,1).*10;
    [p0,s,l_in] = qp(A,-g, gradf ,HessL, p0, l_in, mu);

    l_out(:,i+1)=-l_in(:,end);
    p=p0(:,end);

    x(:,i+1)=x(:,i)+p;
end

