function f = expon_fit(t, G, tMax)

tIp = min(t):0.001:max(t);
G = interp1(t, G, tIp);

[gPeak, tPeak] = findpeaks(G, tIp);

gPeak = gPeak-mean(gPeak(tPeak>tMax));

f = fit(tPeak', gPeak', 'exp1');

plot(f, tPeak, gPeak)
end
