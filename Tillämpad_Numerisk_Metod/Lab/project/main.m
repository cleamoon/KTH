%% This Error value is the ratio to u0 we want to reach after a certain distance 
Error = 0.01;
%% This value is the maximum length of the pipe to calculate
zend = inf;

%% script
u0 = 0.1;
R=0.05;  
nu=10^-5; 
n=50;
hr = R/n;
U = ones(2*n, 1);
Uold = [ones(n, 1)*u0; 0; zeros(n-1, 1)];
z = 0;
hz = 0.001;
dU = ones(2*n, 1);
tol = Error*u0*0.01;
ErrorInput = Error*u0;
uapp = (2*u0*(1-(((1:n)-1).^2*hr^2)./R^2))';
vapp = zeros(n-1,1);


i = 1;
format long
Us = Uold;
zs = 0;
while true
  if z <= 0.005
    hz = R/n;
  elseif z <= 0.04
    hz = 5*R/n;
  elseif z <= zend
    hz = 5*R/n + z/320;
  else 
    break;
  end
  z = z + hz;
  zs = [zs z];
  while true
    J = JacobianM(U, Uold, hz, n);
    f = funcF(U, Uold, hz, n);
    dU = J\f;
    if norm(dU) < tol
      break;
    end
    U = U-dU;
  end
  Us = [Us U];
  Uold = U;
  max([max(abs(U(1:n)-uapp)), max(abs(U(n+2:2*n)-vapp))]);
  if max([max(abs(U(1:n)-uapp)), max(abs(U(n+2:2*n)-vapp))]) < ErrorInput
      break;
  end
end

% figure();
% hold on;
% for i = 1:length(zs)
%     quiver(zs(i), 0, Us(1, i), 0);
%     for j = 2:n
%         quiver(zs(i), (j-1)*hr, Us(j, i), Us(j+n, i));
%     end
% end
% quiver(zs(end), 0, uapp(1, end), 0);
% for j = 2:n
%     quiver(zs(end), (j-1)*hr, uapp(j, end), 0);
% end
figure()
hold on;
for i = 1:n
    plot(zs, Us(i, :), 'b-')
end
for i = 1:n
    plot(zs(end), uapp(i), 'r*')
end
title('Longitudinal velocity against distance plot')
xlabel('Distance since the start of the pipe: z (m)')
ylabel('Velocity in longitudinal direction: u (m/s)')
text(zs(end)+10, 1.1*u0, 'Blue lines are numerical results')
text(zs(end)+10, 0.9*u0, 'Red * are the analytical results')
figure()
hold on;
range = 1:n;
plot(Us(range, end), (range-1)*hr, 'ro-')
plot(uapp(range), (range-1)*hr, 'b*-')
title('Longitudinal velocity at different r')
xlabel('Longitudinal velocity u (m/s)')
ylabel('Position in r-direction')
figure()
hold on
for i = 2:n
    plot(zs, Us(i+n, :), 'b-')
end
for i = 1:n-1
    plot(zs(end), vapp(i), 'r*');
end
title('Transversal velocity against distance plot')
xlabel('Distance since the start of the pipe: z (m)')
ylabel('Velocity in transversal direction: u (m/s)')
text(zs(end)/2, -1.1*u0/2, 'Blue lines are numerical results')
text(zs(end)/2, -0.9*u0/2, 'Red * are the analytical results')
figure()
hold on;
range = 2:n;
plot(Us(range+n, end), (range-1)*hr, 'ro-')
plot(vapp(range-1), (range-1)*hr, 'b*-')
title('Transversal velocity at different r')
xlabel('Transversal velocity v (m/s)')
ylabel('Position in r-direction')

fprintf('The residual is archived after %f m pipe!\n', z);