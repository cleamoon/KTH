%   
%   FSC_fit_JF takes as argument a vector with two elements 
%     corresponding to initial guesses of m and Ywall. It 
%     calculates the sum of the squared difference between 
%     Falkner-Skan similarity solution and the experimentally
%     measured profile.
%
%     y = FSC_fit_JF(par)
% 
%     Contact: Jens Fransson (JF): jensf@kth.se 
%     Responsible person for the Adverse Pressure Gradient LAB KTH/SCI/MEK
%     Date: Sept. 2, 2011
%
%=================================================================

%function y = FSC_fit_JF(par)
%global Y U Uf

% OCT. 2012: JF
function y = FSC_fit_JF(par,Y, U, Uf)

m = par(1) ;
yw = par(2) ;

Ytemp = Y - yw ;

int_1 = 1 - U/Uf ;
n1 = 1 ;
d1 = trapz([0; Ytemp(n1:end)], [1; int_1(n1:end)]) ;
Yd = Ytemp/d1 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 100 ; 
yinf = 20 ; 
[y, t] = ChebStabPoly(4, N-1, 0, 0) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yspan = (yinf / 2) * (1 + y) ;

Theta = 0 ;
H = 0.11 ;
n = N ;

%[U0,U1,U2,W,W1,W2,yout_FS] = TestFSC_jf(m,Theta,n,yinf,H) ;
% OCT. 2012: JF
[U0,~,~,~,~,~,yout_FS] = TestFSC_jf(m,Theta,n,yinf,H) ;


Uorg = interp1(yout_FS, U0, flipud(yspan)) ;

yout_org = flipud(yspan) ;

int1_org = 1 - Uorg(1:end-1) ;
d1_org = trapz([yout_org(1:end-1)], [int1_org]) ;

yout_org2 = yout_org/d1_org ;

U_TEO = interp1(yout_org2(1:end-1), Uorg(1:end-1), Yd) ;


%=================================================================

figure(100), clf
plot(U/Uf, Yd, 'ro', 'markerfacecolor', 'r'), hold on
plot(U_TEO, Yd, 'r-'), hold on
plot(U_TEO, Yd, 'bo'), hold on
drawnow

%=================================================================


y = sum ((U/Uf-U_TEO).^2) ;
