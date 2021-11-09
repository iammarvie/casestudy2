%% This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate

function f = siroutput_full(x,t)

% Here is a suggested framework for x.  However, you are free to deviate
% from this if you wish.

% set up transmission constants

k_new_infections = x(1); % percent of suseptable people who get infections 
k_infections = x(2);
k_fatality = x(3);
k_recover = x(4); %recovered with imunity
k_recover_s = x(5);

% set up initial conditions
ic_susc = x(6);
ic_inf = x(7);
ic_rec = x(8);
ic_fatality = x(9);


% Set up SIRD within-population transmission matrix
% This assumes immunity does not decay

A = [(1-k_new_infections),k_recover_s, 0, 0;
     k_new_infections, k_infections, 0, 0;
     0, k_recover, 1, 0;
     0, k_fatality, 0, 1;];

% The next line creates a zero vector that will be used a few steps.
B = zeros(4,1);

% Set up the vector of initial conditions
x0 = [ic_susc ic_inf ic_rec ic_fatality];

% Here is a compact way to simulate a linear dynamical system.
% Type 'help ss' and 'help lsim' to learn about how these functions work!!
sys_sir_base = ss(A,B,eye(4),zeros(4,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

% return the output of the simulation
f = y;

end