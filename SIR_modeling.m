
% making the sir base fit model
t = 1000;%number of days
pop = sus+inf+rec+dec;
sus = .75;
inf = .10; %infection rate
rec = .10; %recovery rate
dec = .05; % death rate
time = ones(0,t);
time = 0:t; % time matrix
sus = ones(1,t); % susceptibility matrix based on time
rec = ones(1,t); %recovery matrix
inf = ones(1,t); %infection matrix
dec =  ones(1,t); %death matrix
for i = 1:t %Loop that calculates the percentage over time(200)
sus(1) = .75;
sus(i+1) = (.95*sus(i))+ (.04*rec(i));
rec(1) = .10;
rec(i+1) = (.85*rec(i) + (.05*sus(i)));
inf(1) = .10;
inf(i+1) = (inf(i) + .10*(rec(i)));
dec(1) = .05;
dec(i+1) = (dec(i) + .01*(rec(i)));
end
%%
%beta = (.05 * sus);%transmission coefficient
%alpha = (.01 * inf); %death rate
%immuac = (.1 * inf); %immuned people
%immuno = (.04 * inf) + sus;
%gamma = (.14 * inf);%recovery rate
%parameters = [beta,gamma,immuac,immuno,gamma];

%%plot the rates over time
figure;
plot(time, sus , 'r');
hold on
plot(time, rec , 'b');
plot(time, inf , 'g');
plot(time, dec);
title("Simulation of epidemic dynamics over a 1000 day period");
legend('susceptible', 'infected', 'recovered', 'deceased');
xlabel('time (days)');
ylabel('fraction population');
