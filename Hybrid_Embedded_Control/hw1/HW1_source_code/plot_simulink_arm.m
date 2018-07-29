%% Loading data
load('arm_state.mat');


%% Parameters
l_1 = 0.75;
l_2 = 0.75;

%% Plotting

for i = 2:length(x.Time)
    pause(x.Time(i)-x.Time(i-1))
    q1 = x.Data(i,1);
    q2 = x.Data(i,2);
    plot(0,0,'o','color','b');
    hold on
    plot(linspace(0,l_1*cos(q1)),linspace(0,l_1*sin(q1)));
    plot(l_1*cos(q1),l_1*sin(q1),'o','color','b');  
    plot(linspace(l_1*cos(q1),l_1*cos(q1)+l_2*cos(q1+q2)),linspace(l_1*sin(q1),l_1*sin(q1)+l_2*sin(q1+q2)));
    plot(l_1*cos(q1)+l_2*cos(q1+q2),l_1*sin(q1)+l_2*sin(q1+q2),'*', 'color','b');  
    hold off
    axis([-2 2 -2 2])
end
