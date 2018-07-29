function [deflb,tetab,fib,pb,ub]=buckle(Ks,Ksigmas,nnode,node_z);

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

% Calculate eigenvalues and eigenvectors
[ub,pb]=eig(Ks,-Ksigmas);
% vecebl=[ub];
% ebl=[pb];
% sdof=nnode*3;
% bc = 'c-f' ; 
% tleng = 1.;             % total length of the beam
% leng = tleng/20;       % uniform mesh (equal size of elements)
% lengthvector = 0:leng:tleng ;
% Create result vector containing deflections, rotations and twist

% separate deflections, rotations and twist in separate vectors
% 

n = 1;
while true
    if(ub(n,3)<1e-10)
        break;
    else
        n = n+1;
    end
end

for i=2:nnode
    deflb(i)=ub(n,3*i-5);
    tetab(i)=ub(n,3*i-4);
end

deflb = sort(deflb);
tetab = sort(tetab);
figure(2)
hold on;
plot(node_z, deflb);
plot(node_z, tetab);

n = 1;
while true
    if(ub(n,3)>1e-10)
        break;
    else
        n = n+1;
    end
end

for i=2:nnode
    fib(i)=ub(n,3*i-3);
end
%plot(node_z, fib);


% 
% deflb = [];
% for j=1:size(ub)
%     for i=2:size(ub)/3
%         if abs(ub(i-1,j))>0
%             tmp = [tmp, ub(3*i-5,j)];
%             deflb = [deflb tmp'];
%         end
%     end
% end
% 
% 
%   for j=1:size(ub)
%     for i=2:size(ub)/3
%  if abs(ub(i-1,j))>0
%     tetab(i,j)=ub(3*i-4,j);
%  end
%     end
%   end
% 
% for j=1:size(ub)
%     for i=2:size(ub)/3
%  if abs(ub(i-1,j))>0
%     fib(i,j)=ub(3*i-3,j);
%  end
%     end
% end
% 
%   
% % Normalise deflections, rotations and twist for plotting purposes
% % only if columns contain elements <> 0
% if abs(deflb)>0 
%     deflb=normc(deflb');
% end
% if abs(tetab)>0
%     tetab=normc(tetab');
% end
% figure (2)
% ax1 = subplot(3,1,1);
% plot(node_z,deflb');title('Beam deflection'); 
% xlabel(ax1,'Length, m')
% ylabel(ax1,'mm')
% ax2 = subplot(3,1,2);
% plot(node_z,tetab);title('Beam rotation');
% xlabel(ax2,'Length, m')
% ylabel(ax2,'deg')
% 
% %Plot buckling modes
% 
% ax3 = subplot(3,1,3);
% plot(node_z,fib);title('Beam twist');
% xlabel(ax3,'Length, m')
% ylabel(ax3,'deg')