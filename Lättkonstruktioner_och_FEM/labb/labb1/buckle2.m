function [pb,ub]=buckle2(Ks,Ksigmas,nnode,node_z,nelem,le)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve beam buckling equation
% File name: buckle.m
% 
% Ks        Structural stiffness matrix
% Ksigmas	Structural inital stiffness matrix
% nnode     number of nodes
% node_z    nodal x-coordinates
%
% pb		Buckling load vector, in numerical order
% ub		matrix of eigenvalue dofs
% 		(row i of ub is buckling mode of buckling load i)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ndof=3*(nelem);

def=zeros(nelem);
theta=zeros(nelem);
twis=zeros(nelem);
% Calculate eigenvalues and eigenvectors


[V,D]=eig(Ks,-Ksigmas);
pb=V;
ub=D;
% Create result vector containing deflections, rotations and twist
% separate deflections, rotations and twist in separate vectors
for j=1:1:size(Ks)
    if abs(V(1,j))<0.000001 && abs(V(2,j))<0.000001
         k=0;
        for i=1:nelem
            twis(i,j)=V(k+3,j);
            k=k+3;
        end
    end
    if abs(V(3,j))<0.000001
         k=0;
        for i=1:nelem
            def(i,j)=V(k+1,j);
            theta(i,j)=V(k+2,j);
            k=k+3;
        end
    end
end

temp=length(def);
temp2=length(twis);
def=[zeros(1,temp);def];
def(:,all(def==0,1))=[];
theta=[zeros(1,temp);theta];
theta(:,all(theta==0,1))=[];
twis=[zeros(1,temp2);twis];
twis(:,all(twis==0,1))=[];

figure(2)
hold on;
ax1 = subplot(3,1,1);
plot(def(:,1))
hold on
plot(def(:,2))
hold on
plot(def(:,3))
title('Deflection')
xlabel(ax1, 'length, m')
ylabel(ax1, 'mm')


hold on;
ax2 = subplot(3,1,2);
plot(theta(:,1))
hold on
plot(theta(:,2))
hold on
plot(theta(:,3))
title('Rotation')
xlabel(ax2, 'length, m')
ylabel(ax2, 'deg')

hold on;
ax3 = subplot(3,1,3);
plot(twis(:,1))
hold on
plot(twis(:,2))
hold on
plot(twis(:,3))
title('Twist')
xlabel(ax3, 'length, m')
ylabel(ax3, 'deg')



% 
% x=0:0.01:le;
% 
% N1=1-3*(x/le).^2+2*(x/le).^3;
% N2=-x+2*(x).^2./le-(x).^3./le.^2;
% N3=1-x/le;
% N4=3*(x/le).^2-2*(x/le).^3;
% N5=(x).^2./le-(x).^3./le^2;
% N6=x/le;
% 
% figure (3)
% if nelem ~= 1
%     g = 3;
% else
%     g = 2;
% end    
%     
% for i=1:1:g
%     for j=1:nelem
%         v=N1.*def(j,i)+N4.*def(j+1,i)+N2.*theta(j,i)+N5.*theta(j+1,i);
%         %twist=N3.*twis(i,j)+N6.*twis(i+1,j);
%         plot(x+node_z(j),v,'b');drawnow;
%         %plot(x+node_z(i),twist,'b');
%         hold on
%     end
% end
% title('Buckling')
% xlabel('length')
% ylabel('deflection')
% 
% 
% 
% % Normalise deflections, rotations and twist for plotting purposes
% % only if columns contain elements <> 0
% 
% % Plot buckling modes
% 
% 
% 
% 
% 
% 
