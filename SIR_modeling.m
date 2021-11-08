close all;
% making the sir base fit model
t = 1000;%number of days

sus = .75; %suseptibility rate
inf = .10; %infection rate
rec = .10; %recovery rate
dec = .05; % death rate

time = 1:t; % time matrix

x_simulated = zeros(4, t);% vector that stores percent population
x_simulated(:,1) = [0.9; 0.1; 0; 0;];
%[sus; inf; rec; dec;]; % initializing starting rates

A = [0.95, 0.04, 0, 0;
     0.05, 0.85, 0, 0;
     0, 0.10, 1, 0;
     0, 0.01, 0, 1;];

for i = 2:t
    x_simulated(:,i) = A*(x_simulated(:,i-1));
end

 
%% plot the rates over time
figure;
plot(time, x_simulated(1,:) , 'r');
hold on
plot(time, x_simulated(2,:), 'b');
plot(time, x_simulated(3,:), 'g');
plot(time, x_simulated(4,:));
title("Simulation of epidemic dynamics over a 1000 day period");
legend('susceptible', 'infected', 'recovered', 'deceased');
xlabel('time (days)');
ylabel('fraction population');
