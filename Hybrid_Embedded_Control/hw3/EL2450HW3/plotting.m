t=data(:,4)./100;
deg=data(:,3);
x=data(:,1);
y=data(:,2);
x_0=0;
y_0=2;
theta_r=90;
d_0=cos(pi.*deg./180).*(x-x_0)+sin(pi.*deg./180).*(y-y_0);

% plot(t,deg)
% grid on
% xlabel('Time')
% ylabel('Degrees')

figure
plot(t,d_0)
grid on
xlabel('Time')
ylabel('d_0')