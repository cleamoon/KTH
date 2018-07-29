%   
%   FPG_LAB_JF_P1 takes as arguments two vectors, the mean
%     streamwise velocity distribution in the wall-normal 
%     direction and its corresponding wall-normal coordinates.
%     The program returns estimates of the wall-position and  
%     the deceleration parameter m using the Falkner-Skan 
%     similarity equation in an iterative least-squares fit 
%     sense to the data.   
%
%     [Ywall, n] = APG_LAB_JF_P1(Y, U)
%
%     Note the dimensions of the arguments: Y [mm] and U [m/s]
% 
%     Contact: Jens Fransson (JF): jensf@kth.se 
%     Responsible person for the Favourable Pressure Gradient LAB KTH/SCI/MEK
%     Date: Nov. 21, 2012
%
%=================================================================

%function [Ywall, n] = APG_LAB_JF_P1(Y, U)
%global Y U Uf
function [Ywall, ny] = FPG_LAB_JF_P1(Y, Uy)



%=================================================================
%   Calculate an initial guess of Ywall


%Uf = mean(Uy(end-3:end)) ; %SEPT. 18, 2014
Uf = mean(Uy(end-1:end)) ;

indy1 = find(Uy/Uf>0.2) ;  
indy2 = find(Uy/Uf<0.55) ; 
n1 = indy1(1) ;
n2 = indy2(end) ;
[P, S] = polyfit(Uy(n1:n2)/Uf, Y(n1:n2), 1) ;
Ywall0 = polyval(P, 0) ;

%=================================================================
%   Calculate Ywall and n based on the initial guesses Ywall0 and n0

n0 = 0.1 ; % Initial guess of n0. n0 < 0 since APG.
par0 = [n0 Ywall0] ;
%par = fminsearch('FSC_fit_JF', par0) ;

% OCT. 2012: JF
par = fminsearch(@(par) FSC_fit_JF(par, Y, Uy, Uf), par0)
      

ny = par(1) ;
Ywall = par(2) ;
   