function [G, I]= discreteMealSampler(const, mealTime, timeSample)
% Simulate a meal at a given time with descrete sample points

% Create default values for sample points
if nargin==1
    timeSample = [0:30:3*60];
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
tInt = time(1):time(end); % time step of 1 min


% Vector of times corresp to meal
const.times = 0:2.5*1440;
% Index of meal
mealIdx = (mealTime+24)*60;

% Gin for fasting except 500 idx after a meal occuring
const.Gin = zeros(1, length(const.times));
const.Gin(mealIdx:mealIdx+500) = protocols.saadMeal(0:500);

% Solve ODEs for meal
ySt = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tInt);

G = ySt(mealIdx+timeSample,3);
I = ySt(mealIdx+timeSample,1);
end