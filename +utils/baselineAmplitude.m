function tMin = baselineAmplitude(t, G, tMax)
%BASELINEAMPLITUDE calculate the time for the functions amplitude to return
%to its basemine
tIp = min(t):0.001:max(t);
G = interp1(t, G, tIp);
t = tIp;
% Test if steady state is a limit cycle
gSteady = G(t>tMax);
stableMean = mean(gSteady);
if (max(gSteady)-min(gSteady))>0.1
    % If it is a limit cycle. Find peaks in G
    [gPeak, tPeak] = findpeaks(G, t);
    % Find mean max value of steady peaks
    peakLimit = mean(gPeak(tPeak>tMax));
    % Find first peak within 1% of this amplitude
    peaks_near_limit = tPeak(abs(gPeak-peakLimit)/peakLimit<0.001);
    tMin = peaks_near_limit(1);
else
    % Find peaks with amplitude>0.005
    [~, tPeak] = findpeaks((G-stableMean), t, 'MinPeakHeight', 0.005*stableMean);
    % Test if critically or uncritically damped (i.e are there peaks?)
    if isempty(tPeak)
        % For critically damped, just use time within
        reasonableG = t(abs(G-stableMean)<0.001);
    else
        reasonableG = t(abs(G-stableMean)<0.001 & t>tPeak(end));        
    end
    tMin = reasonableG(1);
end
end

