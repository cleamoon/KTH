%% Initialization
X = load('output.csv');

%% Animation
figure(1)
h = animatedline;
for i = 1:X(1, end)
    plot(X(i,2:2:end),X(i,3:2:end), '*');
    drawnow
end


%% max min
figure(2)
for i = 1:X(1, end)
subplot(2,2,1);
plot(i, max(X(i, 2:2:end)), '*');
hold on;
subplot(2,2,2);
plot(i, min(X(i, 2:2:end)), '*');
hold on;
subplot(2,2,3);
plot(i, max(X(i, 3:2:end)), '*');
hold on;
subplot(2,2,4);
plot(i, min(X(i, 3:2:end)), '*');
hold on;
end

%% medium, derivation
figure(3)
for i = 1:X(1, end)
subplot(2,2,1);
plot(i, median(X(i, 2:2:end)), '*');
hold on;
subplot(2,2,2);
plot(i, std(X(i, 2:2:end)), '*');
hold on;
subplot(2,2,3);
plot(i, median(X(i, 3:2:end)), '*');
hold on;
subplot(2,2,4);
plot(i, std(X(i, 3:2:end)), '*');
hold on;
end