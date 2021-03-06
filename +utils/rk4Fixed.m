function y = rk4Fixed(model, state, const, times, nDim)
% Implementation of a user defined rk4 ODE solver

if nargin==4
    nDim = 6;
end

%% Create empty vector of y solutions and add IC
y = zeros(length(times)-1,nDim);
y(1,:) = state;

%% Loop over implementation
for i=1:length(times)-1
    y(i+1,:) = utils.rk4step(model, times(i), times(i+1), y(i,:)', const);
end
end