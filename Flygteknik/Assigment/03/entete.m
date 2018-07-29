%========================================================================
% .. entete script matlab - kristof - August 2011
%    (clear all a ajouter si necessaire AVANT !)
%
%    replacer les axes "au dessus" de tout le reste lors du trac? eps
%    set(gca,'layer','top')
%
%    trac? vectoriel le plus propre possible
%    print -opengl / -painters -depsc2 
%
%    jet1 = colormap(jet(128));
%    jet1(1,:) = [1,1,1];
%    
%    gray(10)
%    gray_invert=gray-1.0;
%    gray_invert=abs(gray_invert);
%
%    film - format 4/3 dimension divisible par 4 - 640 x 480
%========================================================================
%addpath c:\allusr\cb1_matlab\matlabcb1;

close all;

colordef none;
whitebg('w');

opengl neverselect

% set(0,'Defaulttextfontname','palatino','DefaulttextFontsize',18, ...
%       'DefaulttextFontweight','normal','FixedWidthFontName','courier'); 
%     
% set(0,'defaultaxesfontname','palatino','defaultaxesfontweight','normal', ...  
%       'defaultaxesfontsize',18,'defaultaxeslinewidth',0.7, ...
%       'defaultaxesFontangle','normal', ...
%       'defaultlinelinewidth',0.8','defaultpatchlinewidth',0.7);
  
  set(0,'Defaulttextfontname','times','DefaulttextFontsize',18, ...
      'DefaulttextFontweight','normal','FixedWidthFontName','courier'); 
    
set(0,'defaultaxesfontname','times','defaultaxesfontweight','normal', ...  
      'defaultaxesfontsize',18,'defaultaxeslinewidth',0.7, ...
      'defaultaxesFontangle','normal', ...
      'defaultlinelinewidth',0.8','defaultpatchlinewidth',0.7);
  
%      'defaultaxesFontangle','italic', ...

set(0,'defaulttextinterpreter','latex')
%set(0,'defaulttextinterpreter','none')

%set(0,'defaultaxesfontname','palatino','defaultaxesfontsize',18);

%set(0,'DefaultFigurePaperPositionMode','auto')



%set(groot,'defaultFigurePaperPositionMode','auto');
%set(0,'DefaultFigurePaperPositionMode','auto');




global jet1


%.. definition couleurs supplementaires
dgreen     = [0. 0.392 0.];
dviolet    = [0.580 0. 0.827];
dorange    = [1. 0.647 0.];
dgrey      = [0.3,0.3,0.3]; 
grey       = [0.4,0.4,0.4]; 
greylight  = [0.9,0.9,0.9]; 
greylight2 = [0.7,0.7,0.7]; 


jet1 = colormap(jet(128));
for id=1:7
    jet1(id,:) = [1,1,1];
end


gray(64);
gray_invert=gray-1.0;
gray_invert=abs(gray_invert);

foot = 0.3048;
inch = 0.0254;

%========================================================================
%========================================================================