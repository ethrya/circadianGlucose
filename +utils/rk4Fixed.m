function y = rk4Fixed(model, state, const, times);
% Implementation of a user defined rk4 ODE solver

%% Create empty vector of y solutions and add IC
y = zeros(length(times)-1, 6);
y(1, :) = state;

%% Loop over implementation
for i=1:length(times)-1
    y(i+1,:) = utils.rk4step(model, t0, t1, yIn, const);
end
end