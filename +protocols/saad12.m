function Gin = saad12(dT)
% Simulate the meal protocol observed in Van Cauter et al. 1992.
% This uses the chen Meal function, assuming
% Meals consumed at 0800, 1400, 2000 after one day to reach baseline
% Inputs
% dT - timestep (min)
% Output
% Gin - vector of glucose absorbtion through time.
%%
t = 0:dT:2*24*60;

k = 5200; b = 80;

% Calculate Idx of meal beginning
mealIdx = [7*60/dT 13*60/dT 19*60/dT]+24*60/dT;

% Create array of each meal by looping over each (identical) meal
meals = zeros(3, length(t));
for i = 1:3
meals(i, mealIdx(i):length(t)) = protocols.saadMeal([0:length(t)-mealIdx(i)]*dT);
end

Gin = sum(meals, 1);
end
