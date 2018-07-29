close all; clear all; clc;
%Given values
MTTF = 3; %months
MTTR = 1/2; %months
%Task1
MTBF = MTTF + MTTR;
Availability = MTTF/MTBF;

%Task2
%Intensities
lambda = 1/MTTF %From state 1 to 2
mu = 1/MTTR %From state 2 to 1
%Intensity matrix
Q = [-lambda lambda; mu -mu]
%Simulate
T = 30000; %Simulation time
t = 0; %Total time
t_1 = 0; %Time in state 1
t_2 = 0; %Time in state 2
n_1 = 1; %Number of visits to state 1
n_2 = 0; %Number of visits to state 2
state = 1;
while(t < T)
time_in_state = 0;
if(state == 1)
time_in_state = exprnd(1/lambda); %Time to changing to state 2
t_1 = t_1 + time_in_state;
state = 2;
n_2 = n_2 + 1;
else
time_in_state = exprnd(1/mu); %Time to changing to state 1
t_2 = t_2 + time_in_state;
state = 1;
n_1 = n_1 + 1;
end
t = t + time_in_state; %Increase total time
end
%Mean time is total time in state divided by number of visits to state
MTTF_1_5 = t_1 / n_1
MTTR_1_5 = t_2 / n_2
MTBF_1_5 = MTTF_1_5 + MTTR_1_5
availablity_2 = t_1 / t
error = abs(availablity_2-Availability) / Availability %Relative margin of error

%Task3
%Probability for changing in 1/100 month
p12 = lambda / 100
p21 = mu / 100
p11 = 1 - p12
p22 = 1 - p21
%Transition matrix
P = [p11 p12 ; p21 p22];
%Run simulation
starting_value = 1;
steps = 1000000; %Number of steps N
chain = zeros(1,steps);
chain(1) = starting_value;
%Number of "visits"/"sessions" in the states
states_sessioncount = [1 0];
for(i= 2:steps)
step_distribution = P(chain(i-1),:);
cum_distribution = cumsum(step_distribution);
r = rand();
next_state = find(cum_distribution>r,1);
%If next state is different from current state
if(next_state ~= chain(i-1))
states_sessioncount(next_state) = states_sessioncount(next_state) + 1;
end
chain(i) = next_state;
end
count1 = length(find(chain == 1))
count2 = length(find(chain == 2))
Total_time = steps * 1/100 %months
Time_1 = count1 * 1/100
Time_2 = count2 * 1/100
%Mean time is total time in state divided by number of visits to state
MTTF_2 = Time_1 / states_sessioncount(1)
MTTR_2 = Time_2 / states_sessioncount(2)
MTBF_2 = MTTF_2 + MTTR_2
Availability_3 = MTTF_2 / MTBF_2
error2 = abs(Availability_3-Availability) / Availability

%Task4
Pa = p12;
Pb = p21;
%Transition matrix
P = [(1-3*Pa) 3*Pa 0 0; Pb (1-Pb-2*Pa) 2*Pa 0; 0 2*Pb (1-2*Pb-Pa) Pa;
0 0 3*Pb (1-3*Pb)]
%Run simulation
starting_value = 1;
steps = 5000000;
chain = zeros(1,steps);
chain(1) = starting_value;
%Number of "visits"/"sessions" in the states
states_sessioncount = [1 0 0 0];
states_sessionWorks = 1; %Number of "visits"/"sessions" in state 1
states_sessionBroken = 0; %Number of "visits"/"sessions" in state 2,3,4
for(i= 2:steps)
step_distribution = P(chain(i-1),:);
cum_distribution = cumsum(step_distribution);
%Randomize next state
r = rand();
next_state = find(cum_distribution>r,1);
%If next state is different from current state
if(next_state ~= chain(i-1))
states_sessioncount(next_state) =states_sessioncount(next_state) + 1;
if(next_state == 2 && chain(i-1) == 1)
states_sessionBroken = states_sessionBroken + 1;
elseif(next_state == 1 && chain(i-1) == 2)
states_sessionWorks = states_sessionWorks + 1;
end
end
chain(i) = next_state;
end
count1 = length(find(chain == 1))
count2 = length(find(chain == 2))
count3 = length(find(chain == 3))
count4 = length(find(chain == 4))
Total_time = steps * 1/100 %months
Time_1 = count1 * 1/100
Time_2 = count2 * 1/100
Time_3 = count3 * 1/100
Time_4 = count4 * 1/100
Time_works = Time_1
Time_broken = Time_2 + Time_3 + Time_4
%Mean time is total time in state divided by number of visits to state
MTTF_4 = Time_works / states_sessionWorks
MTTR_4 = Time_broken / states_sessionBroken
MTBF_4 = MTTF_4 + MTTR_4
Availability4 = MTTF_4 / MTBF_4

%Task5
Pa = p12;
Pb = p21;
P = [(1-2*Pa) 2*Pa 0; Pb (1-Pb-Pa) Pa; 0 2*Pb (1-2*Pb)]
%Run simulation
starting_value = 1;
steps = 5000000;
chain = zeros(1,steps);
chain(1) = starting_value;
%Number of "visits"/"sessions" in the states
states_sessioncount = [1 0 0];
states_sessionWorks = 1; %Number of "visits"/"sessions" in state 1, 2
states_sessionBroken = 0; %Number of "visits"/"sessions" in state 3
for(i= 2:steps)
step_distribution = P(chain(i-1),:);
cum_distribution = cumsum(step_distribution);
%Randomize next state
r = rand();
next_state = find(cum_distribution>r,1);
%If next state is different from current state
if(next_state ~= chain(i-1))
    states_sessioncount(next_state) =states_sessioncount(next_state) + 1;
if(next_state == 3 && chain(i-1) == 2)
states_sessionBroken = states_sessionBroken + 1;
elseif(next_state == 2 && chain(i-1) == 3)
states_sessionWorks = states_sessionWorks + 1;
end
end
chain(i) = next_state;
end
count1 = length(find(chain == 1))
count2 = length(find(chain == 2))
count3 = length(find(chain == 3))
count4 = length(find(chain == 4))
Total_time = steps * 1/100 %months
Time_1 = count1 * 1/100
Time_2 = count2 * 1/100
Time_3 = count3 * 1/100
Time_4 = count4 * 1/100
Time_works = Time_1 + Time_2
Time_broken = Time_3
%Mean time is total time in state divided by number of visits to state
MTTF_5 = Time_works / states_sessionWorks
MTTR_5 = Time_broken / states_sessionBroken
MTBF_5 = MTTF_5 + MTTR_5
Availability5 = MTTF_5 / MTBF_5
