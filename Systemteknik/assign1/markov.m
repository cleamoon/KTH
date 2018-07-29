%% Assignment 1


%% Problem 2
clc;
Q = [-1/3 1/3; 2 -2];
q1 = 1/3; 
q2 = 2;
now = 0; % time pass from the beginning
state = 1; % name of the state 
tf = []; % list of the simulated time to failure
tr = []; % list of the simulated time to repair
mf = []; % list of the simulated mean time to failure
mr = []; % list of the simulated time to repair
mfb = false; % the check weither the mean time to failure satisfies the error condition
mrb = false; % the check weither the mean time to repair satisfies the error condition
for t=0:1:inf
    if(state == 1)
        h = exprnd(1/q1);
        tf = [tf h];
        mf = [mf mean(tf)];
        if (size(mf)*[0;1]>20)
            if and((abs(mf(end)-mf(end-1))<0.01*mf(end-1)), (abs(mf(end)-3)<0.03))
                if (mrb == true)
                    break;
                else
                    mfb = true;
                end
            end
        end
        now = now + h;
        state = 2;
    else
        h = exprnd(1/q2);
        tr = [tr h];
        mr = [mr mean(tr)];
        if (size(mr)*[0;1]>20)
            if and((abs(mr(end)-mr(end-1))<0.01*mr(end-1)), abs(mr(end)-0.5<0.005))
                if(mfb == true)
                    break;
                else
                    mrb = true;
                end
            end
        end
        now = now + h;
        state = 1;
    end
end

disp(mf(end));
disp(mr(end));
disp(t);

hold on;
title('The convergence of the meantime')
xlabel('Amount of tests');
ylabel('Mean times');
plot(mf, 'b-.');
plot(mr, 'r-');
legend('Meantime to Failure', 'Meantime to Repair', 'Location', 'East');


%% Problem 3

clc;
hold off;
Q = [-1/3 1/3; 2 -2];
now = 0; % time pass from the beginning
state = 1; % name of the state 
tf = []; % list of the simulated time to failure
tr = []; % list of the simulated time to repair
mf = []; % list of the simulated mean time to failure
mr = []; % list of the simulated time to repair
mfb = false; % the check weither the mean time to failure satisfies the error condition
mrb = false; % the check weither the mean time to repair satisfies the error condition
t1 = 0; % time recorder for failure
t2 = 0; % time recorder for repair
h = 0.01; % time step
P = expm(Q.*0.01);
while (now<5000)
    y = rand;
    if state==1
        if y > P(1,1)
            state = 2;
            t1 = t1 + h;
            tf = [tf t1];
            mf = [mf mean(tf)];
            if (size(mf)*[0;1]>20) 
                if and((abs(mf(end)-mf(end-1))<0.01*mf(end-1)), (abs(mf(end)-3)<0.03))
                    if (mrb == true)
                        break;
                    else
                        mfb = true;
                    end
                end
            end
            t1 = 0;
            now = now + h;
        else
            t1 = t1 + h;
            now = now+h;
        end
    else
        if y < P(2,2)
            t2 = t2+h;
            now = now + h;
        else
            state = 1;
            t2 = t2+h;
            tr = [tr t2];
            now = now + h;
            t2 = 0;
            mr = [mr mean(tr)];
            if (size(mr)*[0;1]>20)
                if and((abs(mr(end)-mr(end-1))<0.01*mr(end-1)), abs(mr(end)-0.5<0.005))
                    if(mfb == true)
                        break;
                    else
                        mrb = true;
                    end
                end
            end
        end
    end
end
        
hold on;
title('The convergence of the meantime')
xlabel('Amount of tests');
title('The convergence of the meantime')
ylabel('Mean times');
disp(mean(tf));
disp(mean(tr));
plot(mf, 'b-');
plot(mr, 'r-.');
legend('Meantime to Failure', 'Meantime to Repair', 'Location', 'East');



%% Problem 4
a=0.9967;  % the possibility of the component remains working.
b=0.0033;  % the possibility of the component breaks.
c=0.0198;  % the possibility of the component got repaired.
d=0.9802;  % the possibility of the component remains broken.

A=[a^3 3*a^2*b 3*a*b^2 b^3; 
    a^2*c a^2*d+2*a*b*c b^2*c+2*a*b*d b^2*d; 
    a*c^2 b*c^2+2*a*c*d a*d^2+2*b*c*d b*d^2;
    c^3 3*c^2*d 3*c*d^2 d^3];

Q = [-l l 0 0; mu -(mu + l) l 0; 0 2*mu -(2*mu + l) l; 0 0 3*mu -3*mu;];
A = expm(Q*1/100);
P = [A(1,1) A(1,2)+A(1,3)+A(1,4); (A(2,1)+A(3,1)+A(4,1))/3 (A(2,2)+A(2,3)+A(2,4)+A(3,2)+A(3,3)+A(3,4)+A(4,2)+A(4,3)+A(4,4))/3];

now = 0; % time pass from the beginning
state = 1; % name of the state 
tf = []; % list of the simulated time to failure
tr = []; % list of the simulated time to repair
mf = []; % list of the simulated mean time to failure
mr = []; % list of the simulated time to repair
mfb = false; % the check weither the mean time to failure satisfies the error condition
mrb = false; % the check weither the mean time to repair satisfies the error condition
t1 = 0; % time recorder for failure
t2 = 0; % time recorder for repair
h = 0.01; % time step
while (now<5000)
    y = rand;
    if state==1
        if y > P(1,1)
            state = 2;
            t1 = t1 + h;
            tf = [tf t1];
            mf = [mf mean(tf)];
            if (size(mf)*[0;1]>200) 
                if (abs(mf(end)-mf(end-1))<0.01*mf(end-1))
                    if (mrb == true)
                        break;
                    else
                        mfb = true;
                    end
                end
            end
            t1 = 0;
            now = now + h;
        else
            t1 = t1 + h;
            now = now+h;
        end
    else
        if y < P(2,2)
            t2 = t2+h;
            now = now + h;
        else
            state = 1;
            t2 = t2+h;
            tr = [tr t2];
            now = now + h;
            t2 = 0;
            mr = [mr mean(tr)];
            if (size(mr)*[0;1]>200)
                if (abs(mr(end)-mr(end-1))<0.01*mr(end-1))
                    if(mfb == true)
                        break;
                    else
                        mrb = true;
                    end
                end
            end
        end
    end
end
        
hold on;
title('The convergence of the meantime')
xlabel('Amount of tests');
title('The convergence of the meantime')
ylabel('Mean times');
disp(mean(tf));
disp(mean(tr));
plot(mf, 'b-');
plot(mr, 'r-.');
legend('Meantime to Failure', 'Meantime to Repair', 'Location', 'East');


%% Problem 5

Q = [-l l 0 ; mu -(mu + l) l ; 0 2*mu -2*mu];
A = expm(Q./100);
P = [(A(1,1)+A(1,2)+A(2,1)+A(2,2))/2 (A(1,3)+A(2,3))/2; A(3,1)+A(3,2) A(3,3)];

now = 0; % time pass from the beginning
state = 1; % name of the state 
tf = []; % list of the simulated time to failure
tr = []; % list of the simulated time to repair
mf = []; % list of the simulated mean time to failure
mr = []; % list of the simulated time to repair
mfb = false; % the check weither the mean time to failure satisfies the error condition
mrb = false; % the check weither the mean time to repair satisfies the error condition
t1 = 0; % time recorder for failure
t2 = 0; % time recorder for repair
h = 0.01; % time step
while (now<5000)
    y = rand;
    if state==1
        if y > P(1,1)
            state = 2;
            t1 = t1 + h;
            tf = [tf t1];
            mf = [mf mean(tf)];
            if (size(mf)*[0;1]>200) 
                if (abs(mf(end)-mf(end-1))<0.01*mf(end-1))
                    if (mrb == true)
                        break;
                    else
                        mfb = true;
                    end
                end
            end
            t1 = 0;
            now = now + h;
        else
            t1 = t1 + h;
            now = now+h;
        end
    else
        if y < P(2,2)
            t2 = t2+h;
            now = now + h;
        else
            state = 1;
            t2 = t2+h;
            tr = [tr t2];
            now = now + h;
            t2 = 0;
            mr = [mr mean(tr)];
            if (size(mr)*[0;1]>200)
                if (abs(mr(end)-mr(end-1))<0.01*mr(end-1))
                    if(mfb == true)
                        break;
                    else
                        mrb = true;
                    end
                end
            end
        end
    end
end
        
hold on;
title('The convergence of the meantime')
xlabel('Amount of tests');
title('The convergence of the meantime')
ylabel('Mean times');
disp(mean(tf));
disp(mean(tr));
plot(mf, 'b-');
plot(mr, 'r-.');
legend('Meantime to Failure', 'Meantime to Repair', 'Location', 'East');
