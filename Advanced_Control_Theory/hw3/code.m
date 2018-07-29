s = tf('s');
G = 10000*(s+2)/(s+3)/(s+100)^2;
G = G*(s-1)/(s+2);
Fsim = F;
Gsim = G;
macro