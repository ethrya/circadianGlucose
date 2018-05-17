function tMin = baselineAmplitude(t, G, tMax)
%BASELINEAMPLITUDE calculate the time for the functions amplitude to return
%to its basemine

% Test if steady state is a limit cycle
gSteady = G(t>tMax);
stableMean = mean(gSteady);
if (max(gSteady)-min(gSteady))>0.1
    % If it is a limit cycle. Find peaks in G
    [gPeak, tPeak] = findpeaks(G, t);
    % Find mean max value of steady peaks
    peakLimit = mean(gPeak(tPeak>tMax));
    % Find first peak within 1% of this amplitude
    peaks_near_limit = tPeak(abs(gPeak-peakLimit)/peakLimit<0.01);
    tMin = peaks_near_limit(1);
else
    [gPeak, tPeak] = findpeaks((G-stableMean), t);
    % Test if critically or uncritically damped
    if isempty(tPeak)
        % For critically damped, just use time with 0.01 of 0
        reasonableG = t(abs(G-stableMean)<0.01);
    else
        reasonableG = tPeak(gPeak<0.01);        
    end
    tMin = reasonableG(1);
end
end

