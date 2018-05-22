function f = expon_fit(t, G, tMax)

tIp = min(t):0.001:max(t);
G = interp1(t, G, tIp);

[gPeak, tPeak] = findpeaks(G, tIp);

if length(tPeak)>0
    try
        gBase = mean(gPeak(tPeak>tMax));
    catch
        gBase = mean(G(tIp>tMax));
        warning("No peaks after tMax")
    end
    gPeak = gPeak-gBase;
    f = fit(tPeak', gPeak', 'exp1', 'StartPoint', [20000, -0.01]);
else
    gBase = mean(G(tIp>tMax));
    G = G - gBase;
    f = fit(tIp', G', 'exp1', 'StartPoint', [20000, -0.01]);
end