%%%Computer Lab 6
clc,clear all,close all
N = 100;
T = 1;
a = 1;
count=1;



for sig = [0.8 1]
       
    
    u1=[];
    u2=[];
    u3=[];
    u1(1,:)=zeros(1,N);
    u2(1,:)=zeros(1,N);
    u3(1,:)=zeros(1,N);
 
    for t=0:sig*2/(N*a):2
      for i=2:N-1
           if  t <= T/2
               u1(count+1,1) = 1;
           elseif t <= T
               u1(count+1,1) = -1;
           elseif t <= 3/2*T
               u1(count+1,1) = 1;
           else
               u1(count+1,1) = -1;
           end

           if  t <= T/2
               u2(count+1,1) = 1;
           elseif t <= T
               u2(count+1,1) = -1;
           elseif t <= 3/2*T
               u2(count+1,1) = 1;
           else
               u2(count+1,1) = -1;
           end

           if  t <= T/2
               u3(count+1,1) = 1;
           elseif t <= T
               u3(count+1,1) = -1;
           elseif t <= 3/2*T
               u3(count+1,1) = 1;
           else
               u3(count+1,1) = -1;
           end

         u1(count+1,i)=(1-sig)*u1(count,i)+sig*u1(count,i-1); %Upwind
         u2(count+1,i)=0.5*(u2(count,i-1)+u2(count,i+1))-0.5*sig*(u2(count,i+1)-u2(count,i-1)); %Lax-Friedrich
         u3(count+1,i)=u3(count,i)-0.5*sig*(u3(count,i+1)-u3(count,i-1))+0.5*sig^2*(u3(count,i+1)-2*u3(count,i)+u3(count,i-1)); %Lax-Wendroff
      end
      u1(count+1, N)=(1-sig)*u1(count,N)+sig*u1(count,N-1);
      u2(count+1, N) = 2*u2(count+1, N-1) - u2(count+1, N-2);
      u3(count+1, N) = 2*u3(count+1, N-1) - u3(count+1, N-2);
      count=count+1;
   end
   figure
   subplot(1,3,1)
   plot(2/N*(1:N), u1(end,:))
   title(['Upwind \sigma =' num2str(sig)])
   xlabel('x')
   ylabel('u(x,2T)')
   
   subplot(1,3,2)
   plot(2/N*(1:N), u2(end,:))
   title(['Lax-Friedrich \sigma =' num2str(sig)])
   xlabel('x')
   ylabel('u(x,2T)')
   
   subplot(1,3,3)
   plot(2/N*(1:N), u3(end,:))
   title(['Lax-Wendroff \sigma =' num2str(sig)])
   xlabel('x')
   ylabel('u(x,2T)')
   
end





%% PART b)%%
clc,clear all,close all
%Constants
L=3; a2=0.1; v=1; Tcool=5; Thot=100;
M=30;
ht=0.1;
T=[];
T(:,1)=ones(1,M)'*Tcool;
tend = 100;
for k=1:100
    if k<=5
    T(1,k) = Tcool+(Thot-Tcool)*sin(pi*(k)/10);
    elseif k<=40
        T(1,k)=Thot;
    else
        T(1,k)=Thot+Tcool*sin(pi*((k)/10-4));
    end
for i=2:M
    T(i,k+1)=(1-ht*a2)*T(i,k)-(T(i,k)-T(i-1,k))+ht*a2*Tcool;
end

end
T(1,101)=Thot+Tcool*sin(pi*((100)/10-4));

figure;
[xMesh, tMesh] = meshgrid(ht:ht:L, 0:ht:tend*ht);
surf(xMesh, tMesh, T',  'EdgeColor', 'none')
title('Solution calculated by Lax-Wendroff method')
ylabel('Time (s)')
xlabel('X coordinate ')

%% Lax-Wendroff
L=3; a=0.1; v=1; Tcool=5; Thot=100;
M=30;
ht=0.1;
T=[];
tend = 100;
T(:,1)=ones(1,M)'*Tcool;
T=ones(M,tend+1);
for k=1:tend
    if k<=5
    T(1,k) = Tcool+(Thot-Tcool)*sin(pi*(k)/10);
    elseif k<=40
        T(1,k)=Thot;
    else
        T(1,k)=Thot+Tcool*sin(pi*((k)/10-4));
    end
%     for i=2:M-2
%         T(i, k+1) = (0.5+0.25-a*ht/2)*T(i-1,k) + (1-ht*a-0.5+a^2*ht^2/2)*T(i,k) + (-0.5+0.25+a*ht/2)*T(i+1,k) + (a*ht-a^2*ht^2/2)*Tcool;
%     end
%     T(M, k) = 2*T(M-1,k)-T(M-2,k);
%     i = M-1;
%     T(i, k+1) = (0.5+0.25-a*ht/2)*T(i-1,k) + (1-ht*a-0.5+a^2*ht^2/2)*T(i,k) + (-0.5+0.25+a*ht/2)*T(i+1,k) + (a*ht-a^2*ht^2/2)*Tcool;
    for i = 2:M-1
        T(i, k+1) = (0.5+0.5-a*ht/2)*T(i-1,k) + (-ht*a+a^2*ht^2/2)*T(i,k) + (-0.5+0.5+a*ht/2)*T(i+1,k) + (a*ht-a^2*ht^2/2)*Tcool;
    end
    T(M,k+1) = 2*T(M-1,k+1) - T(M-2,k+1);
end
T(1,tend+1)=Thot+Tcool*sin(pi*((tend)/10-4));
%surf(T, 'EdgeColor', 'none')

figure;
[xMesh, tMesh] = meshgrid(ht:ht:L, 0:ht:tend*ht);
surf(xMesh, tMesh, T',  'EdgeColor', 'none')
title('Solution calculated by Lax-Wendroff method')
ylabel('Time (s)')
xlabel('X coordinate ')