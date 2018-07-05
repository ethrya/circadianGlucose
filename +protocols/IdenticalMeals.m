function [times, Gin] = IdenticalMeals(mealSize, nDays, deltaT)
%% Function to simulate decaying meals. Meals consumed at 0700, 1200, 1900
% Assume meal decays exponentially and time starts at midnight
% INPUTS
% mealSize: peak ingestion rate of the meal (mg/min)
% nDays (integer): Number of days of simulation
% OUTPUTS:
% Gin: glucose infusion rate (mg/min)
% times: times corresponding to Gin values (min)

tConst = 120;
mealTimes = [7 14 20];

times = 0:deltaT:1440*nDays;
Gin = zeros(1, length(times));

for day = 0:nDays-1
    mealIdx = [mealTimes(1)*60+day*1440 mealTimes(2)*60+day*1440 ...
                mealTimes(3)*60+day*1440];
    % Simulate 1st meal
    Gin(mealIdx(1):mealIdx(2))= mealSize*exp(-(0:mealIdx(2)-mealIdx(1))/tConst);
    % Simulate 2nd Meal
    Gin(mealIdx(2):mealIdx(3))= mealSize*exp(-(0:mealIdx(3)-mealIdx(2))/tConst);
    % Simulate 3rd Meal (4 hours)
    Gin(mealIdx(3):mealIdx(3)+4*60)= mealSize*exp(-(0:4*60)/tConst);
end

