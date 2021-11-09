test_data = COVID_MO(isbetween(COVID_MO.date,datetime('2021-01-01'),datetime('2021-10-01')), :);

%% Select the Data to be fit

coviddata = double(table2array(test_data(:,[3:4])))./(150198 + 2805473 + 475220);
period = test_data;
t = height(coviddata);
dates =  table2array(period(:,1)); 

sirafun= @(x)sirloutput(x,t,coviddata);

%%
A = [];
b = [];
Af = [1 1 1 1 1 1 1 0 0 0 0 0; 0 0 0 0 0 0 0 1 1 1 1 1];
bf = [1; 1];
ub = [0.30, .995, 0.1, 1, 0.5, 0.5, 1, 1, 0.7, 1, 0.2, 0.1]';
lb = [0, 0, 0, 0, 0, 0, 0,.90, 0, 0, 0, 0]';

% Specify some initial parameters for the optimizer to start from
% form of x = [new_infections, continued infections, fatalities, recovery with immunity, initial S, intial I, initial R, initial D]

x0 = [0.05,0.85,0.01,0.1,0,0,0.04,1,0,0,0,0]; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you 
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

%plot(Y);
%legend('S',L','I','R','D');
%xlabel('Time')

Y_fit = sirloutput_full(x,t);
%%
k_new_infections = x(1); % percent of suseptable people who get infections 
k_infections = x(2);
k_fatality = x(3);
k_recover = x(4); %recovered with imunity
k_recover_s = x(5);
k_new_lockdown = x(6);
k_lockdown = x(7);
current_policy = [(1-k_new_infections-k_new_lockdown),   1-k_lockdown, k_recover_s,  0,   0;
     k_new_lockdown,                        k_lockdown,          0   ,  0,   0;
     k_new_infections,                               0, k_infections,   0,   0;
     0,                                              0, k_recover,      1,   0;
     0,                                              0, k_fatality,     0,   1;];
 
 
 
 Y_with_Policy = zeros(5, t);
 Y_with_Policy(:,1) = x0(8:12);

 for i = 2:t
 
     Y_with_Policy(:,i) = current_policy*( Y_with_Policy(:,i-1));
     current_policy = sirpolicy(current_policy, Y_with_Policy(:,i));
 
 end
 
 %%
figure();
hold on;
plot(Y_fit);
plot(Y_with_Policy');
datetick('x', 'yyyy-mm-dd','keepticks');
hold off;
legend('S-Without Policy','L-Without Policy','I-Without Policy','R-Without Policy','D-Without Policy','S- With Policy','L- With Policy','I- With Policy','R- With Policy','D- With Policy')
xlabel('Dates')
ylabel('Percentage Population')
title("SLIRD Fit with a Lockdown Policy " + datestr(dates(1)) + " to " + datestr(dates(length(dates))))
 