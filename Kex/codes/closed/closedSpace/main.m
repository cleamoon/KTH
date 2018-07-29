%% Initialization
global M r Mobsp Mobse ne t pp exy up ue vp ve tend S;
initialization();
figure;
% imshow(mat2gray(1.-M')); % display the map
hold on;
setObservableRegion(r);
setObservableRegion(ne);
% imshow(mat2gray(Mobsp*0.3+1-M)); % display the map
hold on;
% plot(pp(:,2), pp(:,1), 'r*'); % plot the locations of pursuers
% plot(exy(2), exy(1), 'bo'); % plot the location of the evader
axis on;

%% Simulation
for t = 1:tend
    weightPursuer();
    weightEvader();
    planPursuer();
    planEvader();
    for i = 1:3
        if norm(up(i,:)) > 1e-5
            pp(i, :) = pp(i, :) + up(i,:)/norm(up(i,:))*vp;
        end
    end
    if norm(ue) > 1e-5; exy(:) = exy(:) + ue(:)/norm(ue(:))*ve; end
    S(:,t+1) = [pp(1,1), pp(1,2), pp(2,1), pp(2,2), pp(3,1) pp(3,2), exy(1), exy(2)];
    if checkCapture()
        tcap = t;
    end
    % setObservableRegion(r);
end

%% Plot
hold on;
% imshow(mat2gray(1-M));
for i = 1:ne
    for j = 1:ne
        if M(i, j) == 1
            plot(i, j, 'ks');
            hold on;
        end
    end
end
hold on;
plot(S(1, 1:t), S(2, 1:t), 'r-');
plot(S(3, 1:t), S(4, 1:t), 'g-');
plot(S(5, 1:t), S(6, 1:t), 'b-');
plot(S(7, 1:t), S(8, 1:t), 'mo');
axis on;