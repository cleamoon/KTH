function [x,s,l] = qp_algorithm(A,b,c,H,x,l,mu)
%
% Function to solve the problem
%                        minimize     c'x + 0.5 x'H x
%                        subject to   A x -s = b
%                                     s >= 0
% using an interior point method

[m, n]=size(A);
u=ones(m,1);
s=mu./l;
eta=0.99; % <1 to avoid to hit the boundary

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
         
        delta(:,i)=K\lhs;
        deltax(:,i)=delta(1:n,i);
        deltas(:,i)=delta(n+1:n+m,i);
        deltal(:,i)=delta(n+m+1:end,i);
        
        deltal2(:,i)=deltal(:,i);
        deltal2(deltal(:,i)>=0,i)=NaN;
        alphal(i)=min(l(:,i)./-deltal2(:,i));
  
        deltas2(:,i)=deltas(:,i);
        deltas2(deltas(:,i)>=0,i)=NaN;
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

%% we can remove these four lines if we want to save all the time history of our interior method
x=x(:,end);     
l=l(:,end);      
s=s(:,end);     

%% we can use the following lines to plot the table of our result at each step

% mu=mu.';
% mu(1)=NaN;
% alphal=[NaN,alphal].';
% alphas=[NaN,alphas].';
% alpha=[NaN,alpha].';
% x=x.';
% l=l.';
% s=s.';
% it=(0:i-1).';
% format shorteng
% T = table(it, mu, alphal, alphas, alpha, x,l,s)

