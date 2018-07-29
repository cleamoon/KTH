function [ F ] = shapeLoop( G, wc, pm)
%ShapeLoop Shapes a open loop with a PI controller
%   G System transfere function
%   wc desired crossover frequency
%   pm desired phase margin

F = tf('s'); 
for i=1:length(G)
   g = G(i, i);     
   a = angle(freqresp(g, wc));
   T = tan(pm - pi/2 - a) / wc;
   
   s = tf('s');
   La = minreal(1 + 1/(s*T));
   
   gain_wcw = abs(freqresp(minreal(g * La), wc));
   K = 1/gain_wcw;
   f = minreal(K * La);
   F(i ,i) = f;
end

end

