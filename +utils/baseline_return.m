function returnTime = baseline_return(tIn, G, tMin)
    %% Time to return to baseline concentration
    % Takes a vector of times and glucose concentrations
    baselineAmount = mean(G(tIn>tMin));
    
    % Calculate index of first instance when within 1% of baseline
    belowBaseIdx = find(G-baselineAmount<0.01*abs(baselineAmount));
    
    % Time of return to baseline
    returnTime = tIn(belowBaseIdx(1));
end