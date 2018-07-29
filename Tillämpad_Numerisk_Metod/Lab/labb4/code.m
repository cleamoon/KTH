
%%LAB 4 Carl & Yue
%%Numerical Solution to a heat equation
clear all,close all, clc

%Defining matrices
figure()
hold on;

for h=[0.1] 
N=30;
dt=0.005;
A=[];
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
u=zeros(1,N)';
U = ones(N, 3/dt+1);

for t=0:dt:3   
if t> 1
    func = 0;
else
    func = 1;
end 

b(1)=func/h^2;

du=A*u+b;

u=u+du*dt;

U(:, floor(t/dt)+1) = u';

end
time=0:dt:10;
figure

% surf(U,'edgecolor','none')

xlabel('Timestep')
ylabel('Lengthstep')
zlabel('U')

end


%% Part 4
A=[];
k=1;
for N=[10 20 40]


odefuncN = @(t,u) odefunc(t,u,N);

time = cputime;
[t,u]=ode23(odefuncN,[0 2],zeros(1,N)',odeset('RelTol',1e-6));
e(k) = cputime-time;
 
times1 =cputime;
 es(k) = cputime-times1;
 
 

timev(k)=length(t);
maxdifft(k)=max(diff(t));

timevs(k)=length(ts);
maxdiffts(k)=max(diff(ts));

k=k+1;



end
A(:,1)=timev;
A(:,2)=timevs;
A(:,3)=e;
A(:,4)=es;
A(:,5)=maxdifft;
A(:,6)=maxdiffts;
format long
A
