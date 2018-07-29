% For an active-set solver you probably want to solve
%
% function [x,lambda] = qp(A,b,c,H,x)
%
% Function to solve the problem
%                        minimize     c'x + 0.5 x'H x
%                        subject to   A x >= b

% You may want to have an optional input argument x for the initial
% value of x.

% If you choose to solve by an interior method, you may also want
% to add slack variables s and Lagrange multipliers lambda which gives
%
function [x,s,l] = qp(A,b,c,H,x, l, mu)
%
% Function to solve the problem
%                        minimize     c'x + 0.5 x'H x
%                        subject to   A x -s = b
%                                     s >= 0



[m, n]=size(A);
u=ones(m,1);
s=mu./l;

eta=0.99;

alpha=1;
i=1;
if eig(H)>0
    while mu(i)>1e-9
        
        S=diag(s(:,i));
        L=diag(l(:,i));
        K=[   H         zeros(n,m)       -A.'
              A        -eye(m,m)     zeros(m,m)
           zeros(m,n)     L              S];
       
        lhs=-[H*x(:,i)+c-A.'*l(:,i)
             A*x(:,i)-s(:,i)-b
             S*L*u-mu(i)*u];

        disp(lhs);
        delta(:,i)=K\lhs;
        deltax(:,i)=delta(1:n,i);
        deltas(:,i)=delta(n+1:n+m,i);
        deltal(:,i)=delta(n+m+1:end,i);
        
        deltal2(:,i)=deltal(:,i);
        deltal2(deltal(:,i)>0,i)=NaN;
        alphal(i)=min(l(:,i)./-deltal2(:,i));
  
        deltas2(:,i)=deltas(:,i);
        deltas2(deltas(:,i)>0,i)=NaN;
        alphas(i)=min(s(:,i)./-deltas2(:,i));
        
        alpha(i)=min([1,eta*alphal(i), eta*alphas(i)]);
        
         x(:,i+1)=x(:,i)+alpha(i)*deltax(:,i);
         s(:,i+1)=s(:,i)+alpha(i)*deltas(:,i);
         l(:,i+1)=l(:,i)+alpha(i)*deltal(:,i);
         
         if norm(lhs)<(n+2*m)*mu(i)
            mu(i+1)=mu(i)/10;
         else
            mu(i+1)=mu(i); 
         end
        i=i+1;
        
    end
else
    disp("The matrix H is not positive definite");  
end