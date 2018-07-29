function [K,Q,M,Ksigma]=assemble(le,EI,GJ,I0,A,J0,q,qt,S,T,m,P,ndof,nelem);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assemble system stiffness matrix, load vector, mass matrix (not necessary)
% and initial stress matrix
% File name: assemble.m
%
% K		System stiffness matrix
% Q		System load vector
% M		System mass matrix
% Ksigma        System initial stress matrix
%
% le		element length [m]
% EI		element bending stiffness [Nm2]
% GJ		element torsional stiffness [Nm2]
% I0		element polar moment of inertia [m4]
% A		element cross-section area [m2]
% J0		element mass moment of inertia [kgm]
% q             element transverse pressure load [N/m]
% qt            element torsion pressure load [Nm/m]
% S             transverse point load [N]
% T             local torque [Nm]
% m		element mass per unit length [kg/m]
% P		applied buckling load [N], positive if tensile
% ndof		number of degrees of freedom
% nelem		number of elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K=zeros(ndof);
Q=zeros(ndof,1);
M=zeros(ndof);
Ksigma=zeros(ndof);
k=0;
for i=1:nelem
    Ke=elk(le,EI,GJ);                                                       %Stiffness matrix
    Qe=elq(le,q,qt);                                                        %Load vector
    Me=elm(le,m);                                                           %Mass matrix
    Kesigma=elksigma(le,P,I0,A);                                            %Initial stiffness matrix
    K(k+1:k+6,k+1:k+6)=K(k+1:k+6,k+1:k+6)+Ke;                               %Assembled stiffness matrix
    Q(k+1:k+6)=Q(k+1:k+6)+Qe;                                               %Assembled Load vector
    Ksigma(k+1:k+6,k+1:k+6)=Ksigma(k+1:k+6,k+1:k+6)+Kesigma;                %Assembled Initial stiffness matrix
    M(k+1:k+6,k+1:k+6)=M(k+1:k+6,k+1:k+6)+Me;                               %Assembled Mass matrix
    k=k+3;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add concentrated loads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q(ndof-2)=Q(ndof-2)+S;                                                      %Concentrated Load at the end of the beam
Q(ndof)=Q(ndof)+T;                                                          %Concentrated Torgue at the end of the beam