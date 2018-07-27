function plotDay(t1, y1, t2, y2, ylab, meanPercent)
% Plotting helper function. plots two 24h time series
% INPUTS:
% t1/t2 - times corresp to t1/t2 (min)
% y1/y2 - output functions
% ylab (str) - ylabel
% meanPercent (booleen; default=1) plot as relative units

if nargin==5
    meanPercent = 1;
end

hold on
% Plot as relative or standard units
if meanPercent==1
    plot(t1/60, utils.meanPercent(y1, 1440,2*1440))
    plot(t2/60, utils.meanPercent(y2, 1440,2*1440),'k')
elseif meanPercent==0
    plot(t1/60, y1)
    plot(t2/60, y2)
else
    error('meanPercent must be a booleen value')
end
hold off
ylabel(ylab)
xticks(24:4:48)
xticklabels(0:4:24)
xlim([24 48])
end