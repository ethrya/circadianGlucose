function returnTime = baseline_return(tIn, G, tMin)
    %% Time to return to baseline concentration
    % Interpolate times and G values
    tIp = min(tIn):0.001:max(tIn);
    GIp = interp1(tIn, G, tIp);
    
    % Takes a vector of times and glucose concentrations
    baselineAmount = mean(GIp(tIp>tMin));
    
    % Calculate index of first instance when within 1% of baseline
    belowBaseIdx = find(GIp-baselineAmount<0.001*abs(baselineAmount));
    
    % Time of return to baseline
    returnTime = tIp(belowBaseIdx(1));
end