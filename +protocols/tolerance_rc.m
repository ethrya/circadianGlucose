% Script to create a tolerance response curve for meals at different times
% of the day
function [gPeak, mealTimes] = toleranceRC(mealSpace)

const = models.constants;
const.g2 = 0.3;


% Set a default mealSpace of 4 hours
if nargin==0
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

mealTimes = 0:mealSpace:24;

gPeak = zeros(1,length(mealTimes));

for mealNo = 1:length(mealTimes)
    const.times = 0:deltaT/2:2.5*1440;
    mealIdx = mealTimes(mealNo)*deltaT/2+24*deltaT/2;
    const.Gin = zeros(1, length(const.times));
    const.Gin(mealIdx:mealIdx+500) = protocols.chenMeal(0:500, 80, 3400);
    
    ySt = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tInt);

    gPeak(mealNo) = max(ySt(tInt>1440,3));
    
end

plot(mealTimes, gPeak)