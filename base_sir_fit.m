
% Here is an example that reads in infection and fatalities from STL City
% and loads them into a new matrix covidstlcity_full
% In addition to this, you have other matrices for the other two regions in question

%covidstlcity_full = double(table2array(COVID_STLcity(:,[5:6])))./300000;

stl = COVID_MO(string(COVID_MO.name) == 'St. Louis', :);
springfield = COVID_MO(string(COVID_MO.name) == 'Springfield', :);
jefferon = COVID_MO(string(COVID_MO.name) == 'Jefferson City', :);
%%
coviddata = double(table2array(stl(:,[3:4])))./2805473;
t = height(stl);
dates =  table2array(stl(:,1)); 

% The following line creates an 'anonymous' function that will return the cost (i.e., the model fitting error) given a set
% of parameters.  There are some technical reasons for setting this up in this way.
% Feel free to peruse the MATLAB help at
% https://www.mathworks.com/help/optim/ug/fmincon.html
% and see the sectiono on 'passing extra arguments'
% Basically, 'sirafun' is being set as the function siroutput (which you
% will be designing) but with t and coviddata specified.
%%
sirafun= @(x)siroutput(x,t,coviddata);

%% set up rate and initial condition constraints
% Set A and b to impose a parameter inequality constraint of the form A*x < b
% Note that this is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
A = [];
b = [];

%% set up some fixed constraints
% Set Af and bf to impose a parameter constraint of the form Af*x = bf
% Hint: For example, the sum of the initial conditions should be
% constrained
% If you don't want such a constraint, keep these matrices empty.
Af = [0 1 1 1 1 0 0 0 0; 0 0 0 0 0 1 1 1 1];
bf = [1; 1];

%% set up upper and lower bound constraints
% Set upper and lower bounds on the parameters
% lb < x < ub
% here, the inequality is imposed element-wise
% If you don't want such a constraint, keep these matrices empty.
ub = [0.30, 1, 0.1, 1, 0.5, 1, 0.7, 1, 0.1]';
lb = [0, 0, 0, 0, 0, .90, 0, 0, 0]';

% Specify some initial parameters for the optimizer to start from
% form of x = [new_infections, continued infections, fatalities, recovery with immunity, initial S, intial I, initial R, initial D]

x0 = [0.05,0.85,0.01,0.1, 0.04,1,0,0,0]; 

% This is the key line that tries to opimize your model parameters in order to
% fit the data
% note tath you 
x = fmincon(sirafun,x0,A,b,Af,bf,lb,ub);

%plot(Y);
%legend('S',L','I','R','D');
%xlabel('Time')

Y_fit = siroutput_full(x,t);


% Test Plot over all st louis data
figure();
hold on;
plot(datenum(dates),Y_fit);
plot(datenum(dates),coviddata);
datetick('x', 'yyyy-mm-dd','keepticks');
hold off;
legend('S','I','R','D','Actual Cases', 'Actual Deaths');
xlabel('Dates')
ylabel('Percentage Population')
title('SIRD Fit for all STL Data')


% Make some plots that illustrate your findings.
% TO ADD