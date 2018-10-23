% Script to calculate bootstrap estimates of median and % samples <81mg/ml
% and the associated uncertaintities
clear var
% Load .mat file that contains nx3 array of G samples from MC simulations
% called (baseG)
load('/import/suphys1/erya7975/simResults/2018-06-30/baselines')
% Models in order of baseG
model = ["Li", "Sturis", "Tolic"];
% Number of boostrap resamples
n = 100000;

% Loop over each model
for i=1:3
    sprintf(model(i))
    % Bootstrap sample of median. Use mean as best estimate and std as
    % boostrap SE estimate
    medSample = bootstrp(n, @(x) median(x), baseG(:,i)/100);
    medMean = mean(medSample);
    medSE = std(medSample);
    sprintf('median +/- SE = %f +/- %f', medMean, medSE)
    
    % Bootstrap samples of % of population with [G]_b<81 mg/ml.
    % Use mean as est of % and std of bootstap samples as SE
    lowSample = bootstrp(n, @(x) sum(x<81)/length(baseG(:,i))*100, baseG(:,i)/100);
    lowMean = mean(lowSample);
    lowSE = std(lowSample);
    sprintf('n<81 +/- SE = %f +/- %f',...
            lowMean, lowSE)
end