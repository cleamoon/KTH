%% global
format long

%% Find K from slides
AR = 9.26; % http://booksite.elsevier.com/9780340741528/appendices/data-a/table-1/table.htm
lambda = 0.251; % taper ratio
ang14 = 29.70;
angl = atand(tand(ang14)+4/4/AR*(1-lambda)/(1+lambda));
e0 = 4.61*(1-0.045*AR^0.68)*((cosd(angl))^0.15)-3.1;
K1 = 1/(pi*AR*e0);
disp('K1'); disp(K1);


%% Find K from Howe
%Mn = 500*0.514/340;
Mn = 0.82;
S = 0.5;
Rw = 5.5;
%§Tf = 1.15;  %?
tc = 12.8/100;
tau = ((Rw-2)/Rw+1.9/Rw*(1+0.526*(tc/0.25)^3));
% f = 0.0062;
f = 0.005*(1+1.5*(lambda-0.6)^2);
Ne = 0;
K2 = (1+0.12*Mn^6)/pi/AR*(1+(0.142+f*AR*(10*tc)^0.33)/cosd(ang14)^2+0.1*(3*Ne+1)/(4+AR)^0.8);
disp('K2'); disp(K2);

% Cd0 = 0.01749533

%% Oswald efficiency factor e0
disp('e0'); disp(e0);
disp('e0_2'); disp(1/K2/pi/AR);