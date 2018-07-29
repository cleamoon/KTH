%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Program
% Beam FE-code for bending about 1-axis and St.Venant torsion
%
% Use SI units exclusively
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Individual data
b=20/1000;
h=40/1000;
tf=3/1000;
tw=1/1000;

% Definitions and input data
L=1.0;		% Length in [m]
E=7E+10;	% Youngs modulus [N/m2]
G=2.6923E+10;	% Shear modulus [N/m2]
I=2.667E-9;	% Moment of inertia about x-axis [m4]
J=1.2E-10;	% Torsional constant [m4]
EI=E*I;		% Bending stiffness [Nm2]
GJ=G*J;		% Torsional stiffness [Nm2]
I0=4E-8;	% Polar moment of inertia [m4]
A=1.2E-4;     % Cross-section area [m2]  ?????????????????
ro=2700;	% Material density [kg/m3]
J0=I0*ro;	% Mass moment of inertia [kgm]

% Loads and masses
m=A*ro;		% mass per unit length of elements [kg/m]
q=1;            % Distributed load [N/m]
qt=0;		% Distributed torque [Nm/m]
S=1;           % Concentrated load at end of beam [N]
T=1;		% Beam end torque [Nm]
P=-1.;		% Buckling load [N]

% Element input data
nelem=20;               % number of elements
le=L/nelem;             % length of elements for even distribution
ndof=3*(nelem+1);	% number of degrees of freedom
nnode=nelem+1;		% number of nodes

% node coordinates
node_z=zeros(nnode,1);
for i=1:nnode
        node_z(i)=le*(i-1);
end

% Assmble stiffness, load, mass and initial stress matrix of the system
[K,Q,M,Ksigma]=assemble(le,EI,GJ,I0,A,J0,q,qt,S,T,m,P,ndof,nelem);

% Apply boundary conditions
% Remove locked dofs at x=0
% K,Q,M and Ksigma are now reduced and structural matrices formed
Ks=K(4:ndof,4:ndof);
Qs=Q(4:ndof);
Ms=M(4:ndof,4:ndof);
Ksigmas=Ksigma(4:ndof,4:ndof);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve beam bending and torsion equation
% and present results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[defl,teta,fi,wmax,tmax,fimax]=bending(Ks,Qs,K,Q,nnode,node_z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve beam buckling equation
% and plot results
% The torsional buckling modes will all give identical load factors
% pb is a vector of buckling loads, given in ascending order
% ub is a matrix of corresponding buckling modes
% (row i of ub is buckling mode of buckling load i)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[pb,ub]=buckle(Ks,Ksigmas,nnode,node_z);

