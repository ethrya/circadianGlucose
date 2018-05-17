function tMin = baselineAmplitude(t, G, tMax)
%BASELINEAMPLITUDE calculate the time for the functions amplitude to return
%to its basemine

% Test if steady state is a limit cycle
gSteady = G(t>tMax);
stableMean = mean(gSteady);
if (max(gSteady)-min(gSteady))/stableMean>0.05
    % if it is a limit cycle. Find peaks in G
    [gPeak, tPeak] = findpeaks(G, t);
    % Find mean max value of steady peaks
    peakLimit = mean(gPeak(t>tMax));
    % Find first peak within 1% of this amplitude
    peaks_near_limit = tPeak(abs(gPeak-peakLimit)/peakLimit<0.01);
    tMin = peaks_near_limit(1);
else
    [~, tPeak] = findpeaks((G-stableMean)/(stableMean),...
        t, 'MinPeakHeight', 0.01);
    if isempty(tPeak)
        tPeak = [0];
    end
    reasonableG = t(abs(G-stableMean)/stableMean<0.01 & t>max(tPeak));
    tMin = reasonableG(1);
end
end

