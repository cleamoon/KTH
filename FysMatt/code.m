%% b uppgiften
n = 500;
lim = 500;
A = zeros(n);
for i = 1:n
A(i,i) = -2;
if i>1
A(i-1,i) = 1;
end
if i<n
A(i+1, i) = 1;
end
end
[V,D] = eig(A);
d = sort(diag(D)*(n*n));
figure;
hold on
title('Numeriska och analytiska läsningar för n=50')
xlabel('x koordinate [m]')
ylabel('amplituden av egenvektor [m]')
step = 1/(n+1):1/(n+1):1-1/(n+1);
s = 1/lim;
plot(step,-V(:, end ), 'r*-') % plot för numeriskt beräknad egenvektor u_1
plot(step, V(:, end-1), 'g*-') % plot för numeriskt beräknad egenvektor u_2
plot(step, V(:, end-2), 'b*-') % plot för numeriskt beräknad egenvektor u_3
plot(s:s:1-s, sin(pi*1*(s:s:1-s))* max(abs(V(:,end))), 'r-') % plot för analytic u_1
plot(s:s:1-s, sin(pi*2*(s:s:1-s))* max(abs(V(:,end))), 'g-') % plot för analytic u_1
plot(s:s:1-s, sin(pi*3*(s:s:1-s))* max(abs(V(:,end))), 'b-') % plot för analytic u_1
legend('n=1','n=2','n=3','n=1','n=2','n=3','Location','Southwest')
%% c uppgiften
n = 100;
x = linspace(1/n,1-1/n,n);
phi=(4+1)/10;
rho = (1+9/20*cos(2*pi*(x+phi)));
B = zeros(n);
for i = 1:n
B(i,i) = -2;
if i>1
B(i-1,i) = 1;
end
if i<n
B(i+1, i) = 1;
end
end
B = diag(1./rho)*B;
[V,D] = eig(B);
dd = sort(diag(D)*(n*n));
figure;
hold on
title('Numeriska läsningar för 100 punkter')
xlabel('x koordinate [m]')
ylabel('amplituden av egenvektor [m]')
step =1/n:1/n:1;
[d, i] = sort(min(D));
V1 = V(:, i(end ));
V2 = V(:, i(end-1));
V3 = V(:, i(end-2));
plot(step, V1(:), 'r*-') % plot för numeriskt beräknad egenvektor u_1
plot(step, V2(:), 'g*-') % plot för numeriskt beräknad egenvektor u_2
plot(step, -V3(:), 'b*-') % plot för numeriskt beräknad egenvektor u_3
legend('n=1','n=2','n=3','Location','Southwest')
%% d uppgiften
n = 1000;
x = linspace(1/n,1-1/n,n);
phi=(4+1)/10;
rho = (1+9/20*cos(2*pi*(x+phi)));
B = zeros(n);
for i = 1:n
B(i,i) = -2;
if i>1
B(i-1,i) = 1;
end
if i<n
B(i+1, i) = 1;
end
end
B = diag(1./rho)*B;
[V, D] = eig(B);
[d, i] = sort(-min(D));
u0 = x.^2.*(1-x);
Vi = zeros(size(V));
for k = 1:size(d)*[0; 1]
Vi(:,k) = V(:,i(k));
end
tend = sqrt(1/d(1));
dt =tend/4;
sum = Vi*diag(Vi\u0');
figure()
title('Resultat med begynnelsevillkor')
xlabel('x-koordinat [m]')
ylabel('u/u0 [1]')
hold on;
for t = 0:dt:tend
u = sum*(cos(t*sqrt(d.*rho))');
plot(x,u)
hold on
end
legend('t1','t2','t3','t4','t5', 'Location', 'Northwest');
%% e)
x = 0:1/1000:1;
uv = (9*cos(2*pi*x))/(80*pi^2 )+x.^2/2-x./2-9/(80*pi^2 );
uc = x.^2/2-x./2;
figure();
title('vågfunktion med yttrekraft')
xlabel('x/L [1]')
ylabel('u [?_0gL^2/S]')
hold on;
plot(x, uv, 'r');
plot(x, uc, 'g');
legend('Varierande densitet', 'Konstant densitet', 'Location','North');
