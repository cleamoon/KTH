function run()
% Here to simplifies the simulation we assume that the runner change its
% longitudinal velocity first and turns later.
global nr S dt D vm a omegam alpha;
for i=1:nr
    s = S(:, i);
    [x, y, v, phi, omg] = deal(s(1), s(2), s(3), s(4), s(5));
    [vd, omegad] = deal(D(1, i), D(2, i));
    % the angle changed during the time step dt
    % gamma = min(1, mod(abs(phid-phi), 2*pi)/alpha(i));
%     omegaa = omg + sign(omegad-omg)*min(alpha(i)*dt, abs(omegad-omg));
%     omegae = min(omegam(i), abs(omegaa))*sign(omegaa);
%     dphi = (omg+omegae)*dt/2;
%     phi = phi + dphi;
    %phi = phid;
%     omega = omegae;
        deltaf = omg;
        deltafd = omegad;
        deltafa = deltaf + sign(deltafd-deltaf)*min(alpha(i)*dt, abs(deltafd-deltaf));
        deltafe = min(omegam(i), abs(deltafa))*sign(deltafa);
        phi = phi + (deltaf+deltafe)*dt;
    % the result velocity because of the acceleration which should not be
    % bigger than the maximum velocity of the runner i
    va = v + sign(vd-v)*min(a(i)*dt, abs(vd-v));
    ve = min(vm(i), abs(va))*sign(va);
    % the distance runned during the time step dt
    ds = (v+ve)*dt/2;
    x = x + ds*cos(phi);
    y = y + ds*sin(phi);
    v = ve;

    S(:, i) = [x y v phi deltafe]';
end
end