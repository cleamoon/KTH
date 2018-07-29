%% Assigment 1
%% Task 0
format long
r_g = 6.356766e6;  % mean value of earth radius, m
k = 1.380622e-23;  % Boltzmann constant, N*m/K
N_A = 6.022169e23;  % Avogadro constant, mol^-1
rho_SSL = 1.225; % density of air, kg/m^3
P_SSL = 1.013250e5; % standard sea-level atmospheric pressure, Pa
T_SSL = 288.15; % standard sea-level temperature, K
S = 110; % Sutherland constant, K
mu_0 = 1.7894e-5; % viscosity
g_0 = 9.80665; % sea-level value of the acceleration of gravity, m/s^2
%% Task 1 
A = [];
step = 1000;
for h = 0:step:25000
    [T, a, P, rho] = atmosisaex(h);
    z = r_g*h/(r_g-h);
    u = mu_0*(T/T_SSL)^(3/2)*((T_SSL+S)/(T+S));
    A = [A [h/1000; z/1000; T; P/1000; rho; a; u]];
end
A1 = A';
xlswrite('T1.xlsx',A1);

rt = [];
rp = [];
rrho = [];
step = 25;
for h = 0:step:25000
    [tt, ~, tp, trho] = atmosisaex(h);
    rt = [rt tt];
    rp = [rp tp];
    rrho = [rrho trho];
end
rt = rt/T_SSL;
rp = rp/P_SSL;
rrho = rrho/rho_SSL;1
%plot(h, rt, h, rp, h, rrho);
hold on;
rr = 0:25:25000;
%plot(rt, rr);

plot(rt, rr, 'color','r');
plot(rp, rr,'color','b');
plot(rrho, rr, 'color','g');
ylabel({'Geopotential altitude (m)'});
xlabel({'Radios'});
txt1 = '\leftarrow \theta(h)=T(h)/T_{SSL}';
text(rt(500),rr(500),txt1);
txt2 = '\leftarrow \delta(h)=p(h)/p_{SSL}';
text(rp(650),rr(650),txt2)
txt3 = '\leftarrow \sigma(h)=\rho(h)/\rho_{SSL}';
text(rrho(350),rr(350),txt3)
title('Ratios of temperature, pressure and density against standard sea-level values')


%% Task 2
small = 5e-5;
for h = 0:1:25000
    [T, a, P, rho] = atmosisaex(h);
    if abs(rho-1.00) < small
        disp('1.00, '); disp(h);
        z = r_g*h/(r_g-h)
    end
    if abs(rho-0.80) < small
        disp('0.80, '); disp(h);
        z = r_g*h/(r_g-h)
    end
    if abs(rho-0.60) < small
        disp('0.60, '); disp(h);
        z = r_g*h/(r_g-h)
    end
    if abs(rho-0.40) < small
        disp('0.40, '); disp(h);
        z = r_g*h/(r_g-h)
    end
    if abs(rho-0.20) < small
        disp('0.20, '); disp(h);
        z = r_g*h/(r_g-h)
    end
    if abs(rho-0.10) < small
        disp('0.10, '); disp(h);
        z = r_g*h/(r_g-h)
    end
end

%% Task 3
p_ground = 100*1000;
T_arctic = -21+273.15;
h_arctic = 8.5*1000;
T_end = -50+273.15;
R = 287.058;
rho_arc = p_ground/(R*T_arctic);
a = (T_end-T_arctic)/h_arctic;
A = [];
step=500;
for h=0:step:h_arctic
    T_a = T_arctic + a*h;
    z = r_g*h/(r_g-h);
    p_a = p_ground*(T_a/T_arctic)^(-g_0/a/R);
    rho_a = rho_arc*(T_a/T_arctic)^(-(g_0/a/R+1));
    A = [A [h/1000; z/1000; T_a; p_a/1000; rho_a]];
    if h==h_arctic
        p_end = p_a;
        rho_end = rho_a;
    end
end

for h = (h_arctic+step):step:15*1000
    T_a = T_end;
    z = r_g*h/(r_g-h);
    ee = exp(-(g_0/(R*T_a))*(h-h_arctic));
    p_a = p_end*ee;
    rho_a = rho_end*ee;
    A = [A [h/1000; z/1000; T_a; p_a/1000; rho_a]];
end
A2 = A';

xlswrite('T3.xlsx',A2);


%% Task 4
p_ground = 100*1000;
T_arctic = 34+273.15;
h_arctic = 13.5*1000;
T_end = -75+273.15;
R = 287.058;
rho_arc = p_ground/(R*T_arctic);
a = (T_end-T_arctic)/h_arctic;
A = [];
step = 500;
for h=0:step:h_arctic
    T_a = T_arctic + a*h;
    z = r_g*h/(r_g-h);
    p_a = p_ground*(T_a/T_arctic)^(-g_0/a/R);
    rho_a = rho_arc*(T_a/T_arctic)^(-(g_0/a/R+1));
    A = [A [h/1000; z/1000; T_a; p_a/1000; rho_a]];
    if h==h_arctic
        p_end = p_a;
        rho_end = rho_a;
    end
end

for h = (h_arctic+step):step:15*1000
    T_a = T_end;
    z = r_g*h/(r_g-h);
    ee = exp(-(g_0/(R*T_a))*(h-h_arctic));
    p_a = p_end*ee;
    rho_a = rho_end*ee;
    A = [A [h/1000; z/1000; T_a; p_a/1000; rho_a]];
end
A3 = A';

xlswrite('T4.xlsx',A3);


%% Task 5
A = [];
step = 25;
diff = 10;
ff = 500*0.3048;
for h = 0:step:15*1000
    [T, a, P, rho] = atmosisaex(h);
    z = r_g*h/(r_g-h);
    u = mu_0*(T/T_SSL)^(3/2)*((T_SSL+S)/(T+S));
    A = [A [h; z; T; P; rho; a; u]];
end
A1 = A';
p_ground = 100*1000;
T_arctic = -21+273.15;
h_arctic = 8.5*1000;
T_end = -50+273.15;
R = 287.058;
rho_arc = p_ground/(R*T_arctic);
a = (T_end-T_arctic)/h_arctic;
A = [];
for h=0:step:h_arctic
    T_a = T_arctic + a*h;
    z = r_g*h/(r_g-h);
    p_a = p_ground*(T_a/T_arctic)^(-g_0/a/R);
    rho_a = rho_arc*(T_a/T_arctic)^(-(g_0/a/R+1));
    A = [A [h; z; T_a; p_a; rho_a]];
    if h==h_arctic
        p_end = p_a;
        rho_end = rho_a;
    end
end

for h = (h_arctic+step):step:15*1000
    T_a = T_end;
    z = r_g*h/(r_g-h);
    ee = exp(-(g_0/(R*T_a))*(h-h_arctic));
    p_a = p_end*ee;
    rho_a = rho_end*ee;
    A = [A [h; z; T_a; p_a; rho_a]];
end
A2 = A';
p_ground = 100*1000;
T_arctic = 34+273.15;
h_arctic = 13.5*1000;
T_end = -75+273.15;
R = 287.058;
rho_arc = p_ground/(R*T_arctic);
a = (T_end-T_arctic)/h_arctic;
A = [];
for h=0:step:h_arctic
    T_a = T_arctic + a*h;
    z = r_g*h/(r_g-h);
    p_a = p_ground*(T_a/T_arctic)^(-g_0/a/R);
    rho_a = rho_arc*(T_a/T_arctic)^(-(g_0/a/R+1));
    A = [A [h; z; T_a; p_a; rho_a]];
    if h==h_arctic
        p_end = p_a;
        rho_end = rho_a;
    end
end

for h = (h_arctic+step):step:15*1000
    T_a = T_end;
    z = r_g*h/(r_g-h);
    ee = exp(-(g_0/(R*T_a))*(h-h_arctic));
    p_a = p_end*ee;
    rho_a = rho_end*ee;
    A = [A [h; z; T_a; p_a; rho_a]];
end
A3 = A';

rag = 0:25:15000;
figure;
hold on;
% Pressure here
plot(A1(1:end,4), rag, 'color', 'b');
plot(A2(1:end,4), rag, 'color', 'r');
plot(A3(1:end,4), rag, 'color', 'g');
ylabel({'Geopotential altitude (m)'});
xlabel({'Pressure (Pa)'});
txt1 = '\leftarrow ISA';
text(A1(150,4),rag(150),txt1, 'color', 'b');
txt2 = '\leftarrow Arctic atmosphere';
text(A2(300,4),rag(300),txt2, 'color', 'r');
txt3 = '\leftarrow Tropical atmosphere';
text(A3(500,4),rag(500),txt3, 'color', 'g');
title('Pressures in different atmospheres');

figure;
hold on;
% Temperature here
plot(A1(1:end,3), rag, 'color', 'b');
plot(A2(1:end,3), rag, 'color', 'r');
plot(A3(1:end,3), rag, 'color', 'g');
ylabel({'Geopotential altitude (m)'});
xlabel({'Temperature (K)'});
txt1 = '\leftarrow ISA';
text(A1(150,3),rag(150),txt1, 'color', 'b');
txt2 = '\leftarrow Arctic atmosphere';
text(A2(300,3),rag(300),txt2, 'color', 'r');
txt3 = '\leftarrow Tropical atmosphere';
text(A3(500,3),rag(500),txt3, 'color', 'g');
title('Temperatures in different atmospheres');

figure;
hold on;
% Density here
plot(A1(1:end,5), rag, 'color', 'b');
plot(A2(1:end,5), rag, 'color', 'r');
plot(A3(1:end,5), rag, 'color', 'g');
ylabel({'Geopotential altitude (m)'});
xlabel({'Density (kg/m^3)'});
txt1 = '\leftarrow ISA';
text(A1(150,5),rag(150),txt1, 'color', 'b');
txt2 = '\leftarrow Arctic atmosphere';
text(A2(300,5),rag(300),txt2, 'color', 'r');
txt3 = '\leftarrow Tropical atmosphere';
text(A3(500,5),rag(500),txt3, 'color', 'g');
title('Densities in different atmospheres');

%% Task 6

pn = 25*1000;
for h=0:ff:25*1000
    [~, ~, p1, ~] = atmosisaex(h);
    [~, ~, p2, ~] = atmosisaex(h+ff);
    %disp(p1);
    %disp(p2);
    if pn >= p2
        if pn < p1
            disp('ISA '); disp(h+ff);
        end
    end
end

p_ground = 100*1000;
T_arctic = -21+273.15;
h_arctic = 8.5*1000;
T_end = -50+273.15;
R = 287.058;
rho_arc = p_ground/(R*T_arctic);
a = (T_end-T_arctic)/h_arctic;
for h=0:step:h_arctic
    T_a = T_arctic + a*h;
    z = r_g*h/(r_g-h);
    p_a = p_ground*(T_a/T_arctic)^(-g_0/a/R);
    if h==h_arctic
        p_end = p_a;
        rho_end = rho_a;
    end
    if pn >= p_ground*((T_a+a*ff)/T_arctic)^(-g_0/a/R)
        if pn < p_a
            disp('arctic '); disp(h+ff);
        end
    end
end

for h = (h_arctic+step):step:15*1000
    T_a = T_end;
    ee = exp(-(g_0/(R*T_a))*(h-h_arctic));
    p_a = p_end*ee;
    if pn >= p_end*exp(-(g_0/(R*T_a))*(h-h_arctic+ff))
        if pn < p_a
            disp('arctic '); disp(h+ff);
        end
    end
end

p_ground = 100*1000;
T_arctic = 34+273.15;
h_arctic = 13.5*1000;
T_end = -75+273.15;
R = 287.058;
rho_arc = p_ground/(R*T_arctic);
a = (T_end-T_arctic)/h_arctic;
for h=0:step:h_arctic
    T_a = T_arctic + a*h;
    p_a = p_ground*(T_a/T_arctic)^(-g_0/a/R);
    if h==h_arctic
        p_end = p_a;
        rho_end = rho_a;
    end
    if pn >= p_ground*((T_a+a*ff)/T_arctic)^(-g_0/a/R)
        if pn < p_a
            disp('tropic '); disp(h+ff);
        end
    end
end

for h = (h_arctic+step):step:15*1000
    T_a = T_end;
    ee = exp(-(g_0/(R*T_a))*(h-h_arctic));
    p_a = p_end*ee;
    if pn >= p_end*exp(-(g_0/(R*T_a))*(h-h_arctic+ff))
        if pn < p_a
            disp('tropic '); disp(h+ff);
        end
    end
end


%% Task 7
a_t = (-56.5+15)/(11*1000-1.6*1000);
p_ground = 101325;
T_arctic = -15+273.15;
h_arctic = 1.6*1000;
T_end = -75+273.15;
R = 287.058;
rho_arc = p_ground/(R*T_arctic);
a = 4/1000;
step = 200;
A = [];
for h=0:step:h_arctic
    T_a = T_arctic + a*h;
    z = r_g*h/(r_g-h);
    p_a = p_ground*(T_a/T_arctic)^(-g_0/a/R);
    rho_a = rho_arc*(T_a/T_arctic)^(-(g_0/a/R+1));
    A = [A [h; z; T_a; p_a; rho_a]];
    if h==h_arctic
        p_end = p_a;
        rho_end = rho_a;
        T_end = T_a;
    end
end
a = (-56.5+15)/(11*1000-1.6*1000);
for h=h_arctic+step:step:3000
    T_a = T_end + a*(h-h_arctic);
    z = r_g*h/(r_g-h);
    p_a = p_end*(T_a/T_end)^(-g_0/a/R);
    rho_a = rho_end*(T_a/T_end)^(-(g_0/a/R+1));
    A = [A [h; z; T_a; p_a; rho_a]];
end
A7 = A';

xlswrite('T7.xlsx',A7);
