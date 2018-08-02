function iAUC = iAUC(G, t, tMeal)
%% Function to calculate the incremental area under the curve
% G - vector of glucose
% t times corresponding to G
% tMeal index of times t corrsponding to meal
% Calculate glucose baseline (assume [G] when meal received)
mealIdx = find(tMeal);
gBase = G(mealIdx(1)-1);

% Calculate time for AUC (i.e. during tMeal and before G returns to
% baseline (G>gBase)

tAUC = tMeal & G>gBase;
tAUCIdx = find(tAUC);
% Calculate AUC
gAUC = trapz(t(tAUC),G(tAUC));

% Subtrace area below baseline
iAUC = gAUC-gBase*(t(tAUCIdx(end))-t(tAUCIdx(1)));

end
