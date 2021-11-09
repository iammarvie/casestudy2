%% This function takes three inputs
% x - a set of parameters
% t - the number of time-steps you wish to simulate
% data - actual data that you are attempting to fit

function f = siroutput(x,t,data)

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
<<<<<<< Updated upstream
% This assumes immunity does not decay

A = [(1-k_new_infections),k_recover_s, 0, 0;
     k_new_infections, k_infections, 0, 0;
=======
A = [1-k_infections, 0, 0, 0;
     k_infections, 1-k_recover, 0, 0;
>>>>>>> Stashed changes
     0, k_recover, 1, 0;
     0, k_fatality, 0, 1;];
B = zeros(4,1);

% Set up the vector of initial conditions
x0 = [ic_susc ic_inf ic_rec ic_fatality];

% simulate the SIRD model for t time-steps
sys_sir_base = ss(A,B,eye(4),zeros(4,1),1);
y = lsim(sys_sir_base,zeros(t,1),linspace(0,t-1,t),x0);

% return a "cost".  This is the quantitity that you want your model to
% minimize.  Basically, this should encapsulate the difference between your
% modeled data and the true data. Norms and distances will be useful here.
% Hint: This is a central part of this case study!  choices here will have
% a big impact!
f = norm(y(:,[2,4])- data);

end