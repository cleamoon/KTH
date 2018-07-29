%% Assignment 2
% Individual data 
alpha_i = 0;
D = 2.5;
d = 0.4;
cr = 12/100;
ct = 9/100;
a0 = 0.11;
cl_max = 1.5;
dcl = 0.3;
dalpha = 1;
BL = 3;

% pre calculation
format long;
pre = 0.001;
plt = 0;
calc = 0;

%% Task 1

if calc == 1
for alpha = 0:pre:90
    if abs(cl_small(alpha, a0, cl_max) - cl_large(alpha, a0, cl_max, dcl)) < (pre/2)
        disp('alpha_cr_test = '); disp(alpha);
    end
end
end
% alpha_cr = 10.2290 - 10.2390, 16.3060 - 16.3080
% the second critical angle of attack is the correct one since it is
% greater than the corresponding stalling angle of attack. If we use
% alpha_cr = (10.2390 + 10.2290) / 2 = 10.2340 then the stalling angle is
% going to be 27.2725 > 10.2340 = alpha_cr.

alpha_cr = (16.3060 + 16.3080) / 2;
disp('alpha_cr = '); disp (alpha_cr);

if calc == 1
for alpha = 0:pre:90
    if abs(cl_max - lift(alpha, a0, cl_max, dcl, alpha_cr)) < pre/50
        disp('alpha_stall_test = '); disp(alpha);
    end
end
end
% alpha_stall = 14.6170 - 14.6560
alpha_stall = (14.6170 + 14.6560) / 2;
disp('alpha_stall = '); disp (alpha_stall);

rg = -25.0:pre:25.0;

cl = [];
cd = [];
for alpha = rg
    cl = [cl lift(alpha, a0, cl_max, dcl, alpha_cr)]; 
    cd = [cd drag(alpha, a0, cl_max)];
end


if plt == 1
figure;
hold on;
plot(rg, cl, 'b-');
xlabel('\alpha');
ylabel('c_l');
title('c_l-\alpha curve')
plot(alpha_cr*ones(ldo+1,1), 0:cl_cr/ldo:cl_cr, 'r-o')
plot(-alpha_cr*ones(ldo+1,1), -(0:cl_cr/ldo:cl_cr), 'r-o')
text(alpha_cr, -.2, '\alpha_{cr}');
text(-alpha_cr-2, .2, '\alpha_{cr}');

cl_st = lift(alpha_stall, a0, cl_max, dcl, alpha_cr);
plot(alpha_stall*ones(ldo+1,1), 0:cl_st/ldo:cl_st, 'm-o')
plot(-alpha_stall*ones(ldo+1,1), -(0:cl_st/ldo:cl_st), 'm-o')
text(alpha_stall-2, -.2, '\alpha_{stall}');
text(-alpha_stall, .2, '\alpha_{stall}');


figure 
hold on;
plot(rg, cd, 'r.');
cl_cr = drag(alpha_cr, a0, cl_max);
ldo = 1;
xlabel('\alpha');
ylabel('c_d');
title('c_d-\alpha curve')
plot(alpha_cr*ones(ldo+1,1), 0:cl_cr/ldo:cl_cr, 'r-o')
plot(-alpha_cr*ones(ldo+1,1), (0:cl_cr/ldo:cl_cr), 'r-o')
text(alpha_cr, 0.005, '\alpha_{cr}');
text(-alpha_cr-2, 0.005, '\alpha_{cr}');

cl_st = drag(alpha_stall, a0, cl_max);
plot(alpha_stall*ones(ldo+1,1), 0:cl_st/ldo:cl_st, 'm-o')
plot(-alpha_stall*ones(ldo+1,1), (0:cl_st/ldo:cl_st), 'm-o')
text(alpha_stall-2, 0.005, '\alpha_{stall}');
text(-alpha_stall, 0.005, '\alpha_{stall}');
end

%% Task 2
cd0 = 0.0092;
k = 0.0141;
clcd_max = 0;

for alpha = 0:pre:25
    clcd = lift(alpha, a0, cl_max, dcl, alpha_cr)/drag(alpha, a0, cl_max);
    if clcd > clcd_max
        clcd_max = clcd;
        alpha_ideal_1 = alpha;
    end
end
disp('the alpha_ideal from data = '); disp(alpha_ideal_1);

alpha_linear_upp = 9;
cLa = lift(alpha_linear_upp, a0, cl_max, dcl, alpha_cr)/alpha_linear_upp;
alpha_ideal_2 = 1/cLa*sqrt(cd0/k);
disp('the alpha_ideal from formular = '); disp(alpha_ideal_2);

alpha_ideal = alpha_ideal_2;
% round off
cl_ideal = lift(alpha_ideal_2, a0, cl_max, dcl, alpha_cr);
cd_ideal = drag(alpha_ideal_2, a0, cl_max);
clcd_ideal = cl_ideal/cd_ideal;
disp('the lift-to-drag ratio with alpha_ideal = '); disp(clcd_ideal);
disp('the lift-to-drag ratio calculated without alpha_ideal = '); disp(1/2/sqrt(cd0*k));


%% Task 3
J_base = 1.2;
V = 100;
R = D/2;
r = d/2;
n = V/(J_base*R*2);
disp ('the rotational frequency = '); disp (n);
beta_base = beta(0.75*R, R, alpha_ideal, J_base);
disp ('beta_base = '); disp(beta_base);


%% Task 4
Phi = [];
Beta = [];
rr = r:pre:R;
for rl = rr
    Phi = [Phi phi_r(rl, R, J_base)];
    Beta = [Beta beta(rl, R, alpha_ideal, J_base)];
end
if plt == 1
figure;
hold on;
axis([0.2 1.25 0 80])
ylabel({'Angles (degree)'});
xlabel({'Radius (m)'});
txt1 = '\leftarrow \phi(r)';
text(rr(500), Phi(500),txt1);
txt2 = '\leftarrow \beta(r)';
text(rr(600), Beta(600),txt2);
txt3 = '\leftarrow \alpha(r)';
text(rr(300), alpha_ideal, txt3);
plot(rr, Phi, 'm.');
plot(rr, Beta, 'b.');
plot(rr, alpha_ideal*ones(size(rr)), 'r.');
end

disp('the blade angle at the root = '); disp(beta(r, R, alpha_ideal, J_base));
disp('the blade angle at the tip = '); disp(beta(R, R, alpha_ideal, J_base));



%% Task 5
Phi1 = [];
Alpha1 = [];
for rl = rr
    p = phi_r(rl, R, J_base-0.1);
    Phi1 = [Phi1 p];
    Alpha1 = [Alpha1 beta(rl, R, alpha_ideal, J_base)-p];
end
Phi2 = [];
Alpha2 = [];
for rl = rr
    p = phi_r(rl, R, J_base);
    Phi2 = [Phi2 p];
    Alpha2 = [Alpha2 beta(rl, R, alpha_ideal, J_base)-p];
end
Phi3 = [];
Alpha3 = [];
for rl = rr
    p = phi_r(rl, R, J_base+0.1);
    Phi3 = [Phi3 p];
    Alpha3 = [Alpha3 beta(rl, R, alpha_ideal, J_base)-p];
end

if plt == 1
figure;
hold on;
plot(rr, Phi1, 'r-', rr, Phi2, 'g--', rr, Phi3, 'b-.');
plot(rr, Beta, 'm.');
legend('\phi(r) when J_{base} = 1.10','\phi(r) when J_{base} = 1.20','\phi(r) when J_{base} = 1.30','\beta(r)')
axis([0.2 1.25 0 80])
xlabel('Radius (m)');
ylabel('Angles (degree)');
title('Same angles with different advance ratios');

figure;
hold on;
plot(rr, Alpha1, 'r-', rr, Alpha2, 'g--', rr, Alpha3, 'b-.');
%legend('\alpha(r) when J_{base} = 1.10','\alpha(r) when J_{base} = 1.20','\alpha(r) when J_{base} = 1.30', 'Location','north')
xlabel('Radius (m)');
ylabel('Angles (degree)');
title('Same angles of attack with different advance ratios');
txt1 = '\leftarrow \alpha(r) when J = 1.10';
text(rr(500), Alpha1(500),txt1);
txt2 = '\leftarrow \alpha(r) when J = 1.20';
text(rr(500), Alpha2(500),txt2);
txt3 = '\leftarrow \alpha(r) when J = 1.30';
text(rr(500), Alpha3(500), txt3);
axis([0.2 1.25 4 10]);
end



%% Task 6
cd1 = [];
cd2 = [];
cd3 = [];
cl1 = [];
cl2 = [];
cl3 = [];
[~, l] = size(rr);
for i = 1:l
    cl1 = [cl1 lift(Alpha1(i), a0, cl_max, dcl, alpha_cr)];
    cl2 = [cl2 lift(Alpha2(i), a0, cl_max, dcl, alpha_cr)];
    cl3 = [cl3 lift(Alpha3(i), a0, cl_max, dcl, alpha_cr)];
    cd1 = [cd1 drag(Alpha1(i), a0, cl_max)];
    cd2 = [cd2 drag(Alpha2(i), a0, cl_max)];
    cd3 = [cd3 drag(Alpha3(i), a0, cl_max)];
end
if plt == 1
figure;
hold on;
plot(rr, cl1, 'r-', rr, cl2, 'g--', rr, cl3, 'b-.');
xlabel('Radius (m)');
ylabel('c_l');
title('Same lift ratios with different advance ratios');
txt1 = '\leftarrow c_{l}(r) when J = 1.10';
text(rr(500), cl1(500),txt1);
txt2 = '\leftarrow c_{l}(r) when J = 1.20';
text(rr(500), cl2(500),txt2);
txt3 = '\leftarrow c_{l}(r) when J = 1.30';
text(rr(500), cl3(500), txt3);
axis([0.2 1.25 0.5 1.1]);

figure;
hold on;
plot(rr, cd1, 'r-', rr, cd2, 'g--', rr, cd3, 'b-.');
xlabel('Radius (m)');
ylabel('c_d');
title('Same drag ratios with different advance ratios');
txt1 = '\leftarrow c_{d}(r) when J = 1.10';
text(rr(500), cd1(500),txt1);
txt2 = '\leftarrow c_{d}(r) when J = 1.20';
text(rr(500), cd2(500),txt2);
txt3 = '\leftarrow c_{d}(r) when J = 1.30';
text(rr(500), cd3(500), txt3);
axis([0.2 1.25 0.012 0.026]);
end



%% Task 7
v1 = [];
v2 = [];
v3 = [];
for i = 1:l
    v1 = [v1 V/sind(Phi1(i))];
    v2 = [v2 V/sind(Phi2(i))];
    v3 = [v3 V/sind(Phi3(i))];
end

if plt == 1
figure;
hold on;
plot(rr, v1, 'r-', rr, v2, 'g--', rr, v3, 'b-.');
legend('V_{R}(r) when J = 1.10','V_{R}(r) when J = 1.20','V_{R}(r) when J = 1.30', 'location', 'northwest')
axis([0.2 1.25 100 320])
xlabel('Radius (m)');
ylabel('Effective freestream velocity V_{R} (m/s)');
title('Effective freestream velocities in different aspect ratios');


figure;
hold on;
plot(rr, v1/340, 'r-', rr, v2/340, 'g--', rr, v3/340, 'b-.');
plot([rr(1) rr(end)], [0.8 0.8], 'm');
legend('V_{R}(r) when J = 1.10','V_{R}(r) when J = 1.20','V_{R}(r) when J = 1.30', 'location', 'west')
axis([0.2 1.25 0.3 0.9])
xlabel('Radius (m)');
ylabel('Effective freestream velocity V_{R} (M_{R})');
title('Different effective freestream velocities in Mach number');
end



%% Task 8

T1 = 0;
T2 = 0;
T3 = 0;
Q1 = 0;
Q2 = 0;
Q3 = 0;
rho = 1.2;
for i = 1:l
    T1 = T1 + 1/2*rho*BL*v1(i)^2*(cl1(i)*cosd(Phi1(i))-cd1(i)*sind(Phi1(i)))*chord(rr(i), cr, ct, R, r)*pre;
    T2 = T2 + 1/2*rho*BL*v2(i)^2*(cl2(i)*cosd(Phi2(i))-cd2(i)*sind(Phi2(i)))*chord(rr(i), cr, ct, R, r)*pre;    
    T3 = T3 + 1/2*rho*BL*v3(i)^2*(cl3(i)*cosd(Phi3(i))-cd3(i)*sind(Phi3(i)))*chord(rr(i), cr, ct, R, r)*pre;    
    Q1 = Q1 + 1/2*rho*BL*v1(i)^2*(cl1(i)*sind(Phi1(i))+cd1(i)*cosd(Phi1(i)))*rr(i)*chord(rr(i), cr, ct, R, r)*pre;
    Q2 = Q2 + 1/2*rho*BL*v2(i)^2*(cl2(i)*sind(Phi2(i))+cd2(i)*cosd(Phi2(i)))*rr(i)*chord(rr(i), cr, ct, R, r)*pre;    
    Q3 = Q3 + 1/2*rho*BL*v3(i)^2*(cl3(i)*sind(Phi3(i))+cd3(i)*cosd(Phi3(i)))*rr(i)*chord(rr(i), cr, ct, R, r)*pre;
end

CT1 = T1/rho/n^2/D^4
CT2 = T2/rho/n^2/D^4
CT3 = T3/rho/n^2/D^4
CQ1 = Q1/rho/n^2/D^5
CQ2 = Q2/rho/n^2/D^5
CQ3 = Q3/rho/n^2/D^5
eta_pr1 = (CT1/CQ1)*(J_base-0.1)/2/pi
eta_pr2 = (CT2/CQ2)*(J_base)/2/pi
eta_pr3 = (CT3/CQ3)*(J_base+0.1)/2/pi
T1
T2
T3



%% Task 9
ch = 5;
cd1 = [];
cd2 = [];
cd3 = [];
cl1 = [];
cl2 = [];
cl3 = [];
for i = 1:l
    cl1 = [cl1 lift(Alpha1(i)+ch, a0, cl_max, dcl, alpha_cr+ch)];
    cl2 = [cl2 lift(Alpha2(i)+ch, a0, cl_max, dcl, alpha_cr+ch)];
    cl3 = [cl3 lift(Alpha3(i)+ch, a0, cl_max, dcl, alpha_cr+ch)];
    cd1 = [cd1 drag(Alpha1(i)+ch, a0, cl_max)];
    cd2 = [cd2 drag(Alpha2(i)+ch, a0, cl_max)];
    cd3 = [cd3 drag(Alpha3(i)+ch, a0, cl_max)];
end

T1 = 0;
T2 = 0;
T3 = 0;
Q1 = 0;
Q2 = 0;
Q3 = 0;
rho = 1.2;
for i = 1:l
    T1 = T1 + 1/2*rho*BL*v1(i)^2*(cl1(i)*cosd(Phi1(i))-cd1(i)*sind(Phi1(i)))*chord(rr(i), cr, ct, R, r)*pre;
    T2 = T2 + 1/2*rho*BL*v2(i)^2*(cl2(i)*cosd(Phi2(i))-cd2(i)*sind(Phi2(i)))*chord(rr(i), cr, ct, R, r)*pre;    
    T3 = T3 + 1/2*rho*BL*v3(i)^2*(cl3(i)*cosd(Phi3(i))-cd3(i)*sind(Phi3(i)))*chord(rr(i), cr, ct, R, r)*pre;    
    Q1 = Q1 + 1/2*rho*BL*v1(i)^2*(cl1(i)*sind(Phi1(i))+cd1(i)*cosd(Phi1(i)))*rr(i)*chord(rr(i), cr, ct, R, r)*pre;
    Q2 = Q2 + 1/2*rho*BL*v2(i)^2*(cl2(i)*sind(Phi2(i))+cd2(i)*cosd(Phi2(i)))*rr(i)*chord(rr(i), cr, ct, R, r)*pre;    
    Q3 = Q3 + 1/2*rho*BL*v3(i)^2*(cl3(i)*sind(Phi3(i))+cd3(i)*cosd(Phi3(i)))*rr(i)*chord(rr(i), cr, ct, R, r)*pre;
end

CT1 = T1/rho/n^2/D^4
CT2 = T2/rho/n^2/D^4
CT3 = T3/rho/n^2/D^4
CQ1 = Q1/rho/n^2/D^5
CQ2 = Q2/rho/n^2/D^5
CQ3 = Q3/rho/n^2/D^5
eta_pr1 = (CT1/CQ1)*(J_base-0.1)/2/pi
eta_pr2 = (CT2/CQ2)*(J_base)/2/pi
eta_pr3 = (CT3/CQ3)*(J_base+0.1)/2/pi
T1
T2
T3
