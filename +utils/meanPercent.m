function relValue = meanPercent(inputVariable, tMin)
% Function to convert time series vector to the value compared to a
% baseline
% INPUT VARIABLES:
% Input variable - 1D vector (e.g. Insulin and glucose concentration)
% tMin - time index to start calculating baseline from
% OUTPUT VARIABLES:
% relValue - transformed inputVariable


%%
% Calculate baseline
baseline = mean(inputVariable(tMin:end));

% Transform inputVariable to value in % of mean units
relValue = (inputVariable)/baseline*100;
end

