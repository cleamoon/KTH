function A=trussanim(xnod,ynod,bars,y)
% TRUSSANIM  Animates oscillations in a truss
%
% TRUSSANIM(X,Y,BARS,A) animates a truss with
% amplitdes given in A. The syntax for X,Y 
% and BARS is the same as for TRUSSPLOT.

n=10;
dt = 2*pi/n;

M = moviein(n);
for j=1:n
  xny = xnod + sin(j*dt)*y(1:2:end);
  yny = ynod + sin(j*dt)*y(2:2:end);
  trussplot(xny,yny,bars);
  axis([min(xnod)-.5,max(xnod)+.5,0,max(ynod)+.5]);
  M(:,j) = getframe;
end
movie(M,20)  % Repeat 20 times
