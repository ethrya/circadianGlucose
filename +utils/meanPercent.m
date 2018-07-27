function relValue = meanPercent(inputVariable, tMin, tMax)
% Function to convert time series vector to the value compared to a
% baseline
% INPUT VARIABLES:
% inputVariable - 1D vector (e.g. Insulin and glucose concentration)
% tMin - time index to start calculating baseline from
% tMax (default=end) - time index to end calculating baseline
% OUTPUT VARIABLES:
% relValue - transformed inputVariable


% set tMax to the end of inputVariable by default
if nargin == 2
    tMax = length(inputVariable);
end

% Calculate baseline
baseline = mean(inputVariable(tMin:tMax));

% Transform inputVariable to value in % of mean units
relValue = (inputVariable)/baseline*100;
end

