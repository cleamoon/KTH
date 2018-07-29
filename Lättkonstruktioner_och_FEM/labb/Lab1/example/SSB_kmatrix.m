function [k] = SSB_kmatrix(DOF,E,I,L,alpha)
% Function with 1 required input, 4 optional.

% Check number of inputs.
if nargin > 5
    error('TooManyInputs! Requires at most 5 optional inputs');
end
% Fill in unset optional values.
switch nargin
    case 1
        E = 29000000;
        I = 200 + (2000-200)*rand();
        L = 10*12 + (30*12-10*12)*rand();
        alpha=ones(DOF+1,1);
    case 2
        I = 200 + (2000-200)*rand();
        L = 10*12 + (30*12-10*12)*rand();
        alpha=ones(DOF+1,1);
    case 3
        L = 10*12 + (30*12-10*12)*rand();
        alpha=ones(DOF+1,1);
    case 4
        alpha=ones(DOF+1,1);
end

%%%%%% SIMPLY SUPPORTED BEAM STIFFNESS MATRIX %%%%%%
%%%%%%         MDOF DYNAMIC ANALYSIS          %%%%%%
%%%%%%           TOM MATARAZZO 2012           %%%%%%

% Equal span lengths for DOF+1 spans.

N=2*DOF;
spans=DOF+1;

% Stiffness Properties (E (lb/in^2), I (in^4),L (in))

% Stiffness weight vector alpha is a column vector with DOF+1 entries

% If DOF < 3 use rpedetermined stiffness to avoid N loop.
k_total=zeros(N,N);

    if DOF == 1
   
    k_total(1,1)= 3/(alpha(1)*L)^3+3/(alpha(2)*L)^3;
    k_total(2,1)= -3/(alpha(1)*L)^2+3/(alpha(2)*L)^2;
    k_total(1,2)= k_total(2,1);
    k_total(2,2)= 3/(alpha(1)*L)+3/(alpha(2)*L);
    
    elseif DOF == 2
    
    k_total(1,1)= 3/(alpha(1)*L)^3+12/(alpha(2)*L)^3;
    k_total(2,1)= -3/(alpha(1)*L)^2+6/(alpha(2)*L)^2;
    k_total(3,1)= -12/(alpha(2)*L)^3;
    k_total(4,1)= 6/(alpha(2)*L)^2;
    k_total(1,2)= k_total(2,1);
    k_total(2,2)= 3/(alpha(1)*L)+4/(alpha(2)*L);
    k_total(3,2)= -6/(alpha(2)*L)^2;
    k_total(4,2)= 2/(alpha(2)*L);
    k_total(1,3)= k_total(3,1);
    k_total(2,3)= k_total(3,2);
    k_total(3,3)= 12/(alpha(spans-1)*L)^3+3/(alpha(spans)*L)^3;
    k_total(4,3)= -6/(alpha(spans-1)*L)^2+3/(alpha(spans)*L)^2;
    k_total(1,4)= k_total(4,1);
    k_total(2,4)= k_total(4,2);
    k_total(3,4)= k_total(4,3);
    k_total(4,4)= 4/(alpha(spans-1)*L)+3/(alpha(spans)*L);
    
    elseif DOF > 2

% Create total stiffness matrix
% Start first two columns and last two columns 
k_total(1,1)= 3/(alpha(1)*L)^3+12/(alpha(2)*L)^3; 
k_total(2,1)= -3/(alpha(1)*L)^2+6/(alpha(2)*L)^2;
k_total(3,1)= -12/(alpha(2)*L)^3;
k_total(4,1)= 6/(alpha(2)*L)^2;

k_total(1,2)= k_total(2,1);
k_total(2,2)= 3/(alpha(1)*L)+4/(alpha(2)*L); 
k_total(3,2)= -6/(alpha(2)*L)^2;
k_total(4,2)= 2/(alpha(2)*L);

k_total(N-1,N-1)= 12/(alpha(spans-1)*L)^3+3/(alpha(spans)*L)^3; 
k_total(N,N-1)= -6/(alpha(spans-1)*L)^2+3/(alpha(spans)*L)^2;
k_total(N-3,N-1)= -12/(alpha(spans-1)*L)^3;
k_total(N-2,N-1)= -6/(alpha(spans-1)*L)^2;

k_total(N-1,N)= k_total(N,N-1);
k_total(N,N)= 4/(alpha(spans-1)*L)+3/(alpha(spans)*L); 
k_total(N-3,N)= 6/(alpha(spans-1)*L)^2;
k_total(N-2,N)= 2/(alpha(spans-1)*L);

for j=3:N-2
    current=j/2-floor(j/2);
    
    %number is odd
    if current==0.5
        k_total(j-2,j)= -12/(alpha((j+1)/2)*L)^3;
        k_total(j-1,j)= -6/(alpha((j+1)/2)*L)^2;
        k_total(j,j)= 12/(alpha((j+1)/2)*L)^3+12/(alpha((j+3)/2)*L)^3;
        k_total(j+1,j)= -6/(alpha((j+1)/2)*L)^2+6/(alpha((j+3)/2)*L)^2;
        k_total(j+2,j)= -12/(alpha((j+3)/2)*L)^3;
        k_total(j+3,j)= 6/(alpha((j+3)/2)*L)^2;
      
      
    %number is even
    elseif current==0
        k_total(j-3,j)= 6/(alpha(j/2)*L)^2;
        k_total(j-2,j)= 2/(alpha(j/2)*L);
        k_total(j-1,j)= -6/(alpha(j/2)*L)^2+6/(alpha(j/2+1)*L)^2;
        k_total(j,j)= 4/(alpha(j/2)*L)+4/(alpha(j/2+1)*L);
        k_total(j+1,j)= -6/(alpha(j/2+1)*L)^2;
        k_total(j+2,j)= 2/(alpha(j/2+1)*L);
      
    end

end
    end
    
k_total=E*I*k_total;

% Build Ktt, Ktr, Krt, and Krr matrices (same size as k_total).
% Contains many extra zeros
Ktt=zeros(N,N);
Krt=zeros(N,N);
Krr=zeros(N,N);


for j=1:N
  jay=j/2-floor(j/2);
  
    for i=1:N
    iye=i/2-floor(i/2);
    
        %j is odd, i is odd
        if jay==0.5 && iye==0.5
        Ktt(i,j)=k_total(i,j);
            
        %j is odd, i is even
        elseif jay==0.5 && iye==0
        Krt(i,j)=k_total(i,j);
        
        %j is even, i is even
        elseif jay==0 && iye==0
        Krr(i,j)=k_total(i,j);
        
        end
    
    end
end

% Use Ktt, Ktr, Krt, and Krr to make ktt, ktr, krt, and krr
% These are the same matrices without the uneccesary zeros
ktt=zeros(DOF,DOF);

jj=0;
ii=0;
for j=1:2:N
    jj=floor(j/2)+1;
    
 for i=1:2:N
     
    ii=floor(i/2)+1;
    
   ktt(ii,jj)=Ktt(i,j); 
  
  end
end

krt=zeros(DOF,DOF);

jj=0;
ii=0;
for j=1:2:N
    jj=floor(j/2)+1;
    
 for i=2:2:N
     
    ii=floor(i/2);
    
   krt(ii,jj)=Krt(i,j); 
  
  end
end

krr=zeros(DOF,DOF);

jj=0;
ii=0;
for j=2:2:N
    jj=floor(j/2);
    
 for i=2:2:N
     
    ii=floor(i/2);
    
   krr(ii,jj)=Krr(i,j); 
  
  end
end

k=ktt-krt'*(krr\krt);

end
    