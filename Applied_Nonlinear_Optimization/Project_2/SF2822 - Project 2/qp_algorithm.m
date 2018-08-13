function [x,s,l,flag, residual] = qp_algorithm(A,b,c,H,x,l,mu)
%
% Function to solve the problem
%                        minimize     c'x + 0.5 x'H x
%                        subject to   A x -s = b
%                                     s >= 0
% using an interior point method

flag=0;         %the flag turns into 1 if the Hessian is not positive definite
[m, n]=size(A); %dimensions of matrix A
u=ones(m,1);    %vector of ones
s=mu./l;        %obtain the slack vector knowing that s_i*l_i=mu
eta=0.99;       % <1 to avoid to hit the boundary

i=1;
residual(:,1)=norm([H*x+c-A.'*l; A*x-s-b ]); %first estimation of the residual
if eig(H)>0 %check if the Hessian is positive definite
    
    while mu(i)>1e-9  %cycle until we reach convergence
        
        S=diag(s(:,i));
        L=diag(l(:,i));
        K=[   H         zeros(n,m)       -A.'
              A        -eye(m,m)     zeros(m,m)
           zeros(m,n)     L              S];
       
        rhs=-[H*x(:,i)+c-A.'*l(:,i)
             A*x(:,i)-s(:,i)-b
             S*L*u-mu(i)*u];
         
        delta(:,i)=K\rhs;  %we solve the system K*delta=rhs to find the steps from a Newton's iteration
        deltax(:,i)=delta(1:n,i); 
        deltas(:,i)=delta(n+1:n+m,i);
        deltal(:,i)=delta(n+m+1:end,i);
        
        %we create a copy of our deltal and deltas
        %and we put to NaN the values greater or equal to zero
        %because we want to calculate the minimum only for the negative
        %values of deltal_i and deltas_i
        deltal2(:,i)=deltal(:,i);
        deltal2(deltal(:,i)>=0,i)=NaN; 
        alphal(i)=min(l(:,i)./-deltal2(:,i));
  
        deltas2(:,i)=deltas(:,i);
        deltas2(deltas(:,i)>=0,i)=NaN;
        alphas(i)=min(s(:,i)./-deltas2(:,i));
        
        %Then we compute the maximum step to guarantee that l and s remain
        %greater than zero
        alpha(i)=min([1,eta*alphal(i), eta*alphas(i)]);
        
        %update x, l and s
         x(:,i+1)=x(:,i)+alpha(i)*deltax(:,i);
         s(:,i+1)=s(:,i)+alpha(i)*deltas(:,i);
         l(:,i+1)=l(:,i)+alpha(i)*deltal(:,i);
         
         %compute the new residual
         residual(:,i+1)=norm([H*x(:,i+1)+c-A.'*l(:,i+1); A*x(:,i+1)-s(:,i+1)-b; l(:,i+1).'*s(:,i+1)-mu(i)*u]);
         
         if residual(:, i+1)<(n+2*m)*mu(i) %if the residual is sufficiently small, reduce mu
            mu(i+1)=mu(i)/10;
         else %otherwise make another iteration with the sam mu
            mu(i+1)=mu(i); 
         end
         
        %update the number of iterations
        i=i+1;
        
    end
else  %if the Hessian is not positive definite
    disp("The matrix H is not positive definite");  
    flag=1; %the flag becomes 1
end

%% we can remove the following lines if we want to save all the time history of our interior method
x=x(:,end);     
l=l(:,end);      
s=s(:,end); 
residual=residual(end);


