function [x,s,lambda] = qp(A,b,c,H,x,s,lambda)
[m, n]=size(A);
u=ones(m,1);
mu(1)=1;
l(:,1)=2*u;
s(:,1)=mu(1)./l;
x=[3 1].';


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
        
        if norm(deltax(:,i))<1e-8
            mu(i+1)=mu(i)/10;
        else
            mu(i+1)=mu(i);
        end
        i=i+1;
        
    end
else
    disp("The matrix H is not positive definite");
end


mu=mu.';
mu(1)=NaN;
alphal=[NaN,alphal].';
alphas=[NaN,alphas].';
alpha=[NaN,alpha].';
x=x.';
l=l.';
s=s.';
it=(0:i-1).';
format shorteng

T = table(it, mu, alphal, alphas, alpha, x,l,s)