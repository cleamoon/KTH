function [defl,teta,fi,umax,tmax,fimax,R,W]=bending(Ks,Qs,K,Q,nnode,node_z)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate deformed beam bending and torsion shape and plot results
% File name: bending.m
%
% Ks		Structural stiffness matrix
% Qs		Structural load vector
% K		System stiffness matrix 
% Q		System load vector
% nnode         number of nodes
% node_z          nodal z-coordinates
%
% defl		deflection vector of size nnodes
% teta		rotation vector of size nnodes
% fi            twist vector of size nnodes
% umax          maximum deflection
% tetamax       maximum rotation
% fimax		maximum twist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clc
% Solve equation system
W=Ks^-1*Qs;
%disp('Printout of Displacement vector')
%disp(W)
% Reaction loads are calculated
[i,~]=size(K);
R=K(1:3,4:i)*W-Q(1:3,1);
% Separate deflections, rotations and twist in separate vectors
for i=2:nnode
    defl(i)=W(3*i-5);
    teta(i)=W(3*i-4);
    fi(i)=W(3*i-3);
end
% Normalise deflections, rotations and twist and plot results
defl 
if defl>0
    defl=normc(defl');
end
if teta>0
    teta=normc(teta');
end
if fi>0
    fi=normc(fi');
end

%Plotting: Deflection, Rotation and Twist.

figure (1)
ax1 = subplot(3,1,1);
plot(node_z,defl*1000);title('Beam deflection'); 
xlabel(ax1,'Length, m')
ylabel(ax1,'mm')
ax2 = subplot(3,1,2);
plot(node_z,teta);title('Beam rotation');
xlabel(ax2,'Length, m')
ylabel(ax2,'deg')
ax3 = subplot(3,1,3);
plot(node_z,fi);title('Beam twist');
xlabel(ax3,'Length, m')
ylabel(ax3,'deg')

% subplot(3,1,1);plot(node_z,defl*1000,);title('deflection'); 
% subplot(3,1,2);plot(node_z,teta);title('rotation');
% subplot(3,1,3);plot(node_z,fi);title('twist');

% figure(1),plot(node_z,defl);title('Deflection');
% xlabel('Length'); ylabel('mm');
% figure(2),plot(node_z,teta);title('Rotation');
% xlabel('Length'); ylabel('deg');
% figure(3),plot(node_z,fi);title('Twist');
% xlabel('Length'); ylabel('deg');
%Compute the maximum value

umax=max(defl);
umin=min(defl);

if abs(umin)>umax
    umax=abs(umin)*(-1);
else
    umax=umax;
end
 
tmax=max(teta);
tmin=min(teta);

if abs(tmin)>tmax
    tmax=tmin;
else
    tmax=tmax;
end

fimax=max(fi);
fimin=min(fi);

if abs(fimin)>fimax
    fimax=fimin;
else
    fimax=fimax;
end

disp('MAXIMUM DISPLACEMENTS')
disp('')
disp(['Maximum deflection:  ',num2str(umax*1000),' mm'])
disp(['Maximum rotation:  ',num2str(tmax),])
disp(['Maximum twist:  ',num2str(fimax),])
disp('')
% Reaction forces printout
disp('')
disp('REACTION FORCES PRINTOUT')
disp(R)
% 
% le = 0.5;
% 
% x=0:0.01:le;
% N1=1-3*(x/le).^2+2*(x/le).^3;
% N2=-x+2*(x).^2./le-(x).^3./le.^2;
% N3=1-x/le;
% N4=3*(x/le).^2-2*(x/le).^3;
% N5=(x).^2./le-(x).^3./le^2;
% N6=x/le;
% figure (1)
% 
% nelem=2;
% 
% for i=1:nelem
% v=N1.*defl(i)+N4.*defl(i+1)+N2.*teta(i)+N5.*teta(i+1);
% twist=N3.*fi(i)+N6.*fi(i+1);
% plot(x+node_z(i),v,'b');
% plot(x+node_z(i),twist,'b');
% hold on
% 
% end
