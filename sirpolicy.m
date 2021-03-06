function [policy_matrix] = sirpolicy(current_policy, slird_vals)
    % Idea behind this is policy is to evalute the next ten time steps and
    % measure the rate of increse of the infection rate. This is used to
    % compute a multipler for the lockdown rate.
    future_rate = zeros(5, 10);
    future_rate(:, 1) = slird_vals;
    for i = 2:10
        future_rate(:,i) = current_policy*(future_rate(:,i-1));
    end
    
    infection = future_rate(3,2:10) - future_rate(3, 1:9);
    
    alpha = infection(9)-infection(1);% measures if the rate of change of the infection rate is positive or negative. 
    
    policy_matrix = current_policy;
    policy_matrix(2,1) = current_policy(2,1)*alpha;
end