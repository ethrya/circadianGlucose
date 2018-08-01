function iAUC = iAUC(G, t, tMeal)
%% Function to calculate the incremental area under the curve

% Calculate glucose baseline (assume [G] when meal received)
gBase = G(tMeal(1));

% Calculate time for AUC (i.e. during tMeal and before G returns to
% baseline (G>gBase)
tAUC = tMeal & G>gBase;

% Calculate AUC
gAUC(mealNo) = trapz(t(tAUC),G(tAUC & G>gBase));

% Subtrace area below baseline
iAUC = gAUC-gBase*(t(tAUC(end))-t(tAUC(1)));

end
