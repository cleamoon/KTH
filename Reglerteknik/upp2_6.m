sys1 = tf([1],[1 2 1]);
stepinfo(sys1)
%T = feedback(sys1,-1)
%pzmap(T)
pole(sys1)
zero(sys1)
