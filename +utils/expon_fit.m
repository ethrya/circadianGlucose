function f = expon_fit(t, G, tMax)

tIp = min(t):0.001:max(t);
G = interp1(t, G, tIp);

exponConst = fittype('a*exp(b*x)+c');

[gPeak, tPeak] = findpeaks(G, tIp);

if length(tPeak)>0
    try
        gBase = mean(gPeak(tPeak>tMax));
    catch
        gBase = mean(G(tIp>tMax));
        warning("No peaks after tMax")
    end
    %gPeak = gPeak-gBase;
    f = fit(tPeak', gPeak', exponConst, 'StartPoint', [G(1), -0.01, gBase]);
else
    gBase = mean(G(tIp>tMax));
    %G = G - gBase;
    f = fit(tIp', G', exponConst, 'StartPoint', [G(1), -0.01, gBase]);
end