% Script to create a tolerance response curve for meals at different times
% of the day
function [gPeak, mealTimes] = tolerance_rc(const, mealSpace)

% Set a default mealSpace of 4 hours
if nargin==1
    mealSpace = 4;
end

% Check that mealSpace is valid
if mod(24, mealSpace)~=0
    error('mealSpace must be factor of 24')
end

% Initial condition for Sturis and Tolic
sturisState = [40; % Ip
    40; % Ii
    10000; % G
    0; % x1
    0; % x2
    0]; % x3

% Integration time bounds (2.5 days)
time = [0, 1440*2.5];
deltaT = 1; % Time step (min)
tInt = time(1):deltaT:time(end);

% Vector of initial meal times
mealTimes = 0:mealSpace:24;
gPeak = zeros(1,length(mealTimes));

% Calculate response to meals
for mealNo = 1:length(mealTimes)
    % Vector of times corresp to meal
    const.times = 0:deltaT/2:2.5*1440;
    % Index of meal
    mealIdx = (mealTimes(mealNo)+24)*2*60/deltaT;
    
    % Gin for fasting except 500 idx after a meal occuring
    const.Gin = zeros(1, length(const.times));
    const.Gin(mealIdx:mealIdx+500) = protocols.chenMeal(0:500, 80, 3400);
    
    % Solve ODEs for meal
    ySt = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tInt);
    
    % Calculate peak glucose within 250 idx of meal
    gPeak(mealNo) = max(ySt(tInt>mealIdx/2 & tInt<mealIdx/2+250,3));

end

%% Plot peak glucose vs meal time
plot(mealTimes, gPeak)
xlabel('Meal Time (zt)')
ylabel('Peak Glucose')
xlim([0 24])
end