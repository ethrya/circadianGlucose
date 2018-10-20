clear;
%% Preliminaries
nDays = 5; % Simulation time (days)
deltaT = 0.5; % Solver timestep (min)

% Import constants class
const = models.constants;
% Change constants from default values
const.Gin = 243;
const.g1 = .25;

% Plot params
nRows = 3; nCol = 1; N =1; tMin = 48;
pltTitle = '';

% Initial condition for Sturis and Tolic
sturisState = [40; % Ip
    40; % Ii
    10000; % G
    0; % x1
    0; % x2 
    0]; % x3

% Integration time (min)
time = [0, 1440*nDays];
  

%% Solve equations
% Simulation time
tSt = 0:1440*nDays; tStC = 0:1440*nDays;


ySt = utils.rk4Fixed(@models.sturis, sturisState, const, tSt);
yStC = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tSt);


%% Plotting
% Convert glucose amounts into concentrations
Ip = ySt(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = ySt(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl
IpC = yStC(:,1)/const.Vp; %[I]=I/Vp microU/ml
GC = yStC(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

% Calculate ISR
ISR = models.funcs.f1(ySt(:,3), const);
const.C = utils.skewSine(tStC/60)';
ISR_circ = models.funcs.f1(yStC(:,3),const);

%% Plot [G] and [I] vs t for all 3 models.
figure()
% Plot [I]
subplot(3,1,1)
hold on
plot(tSt/60, Ip)
plot(tStC/60, IpC)
hold off
ylabel('[I] (\muU/ml)')
legend('Original', 'New')
xlim([tMin 24*nDays])
xticks(0:6:nDays*24)
xticklabels([])
% Plot [G]
subplot(3,1,2)
hold on
plot(tSt/60, G)
plot(tStC/60, GC)
xlim([tMin 24*nDays])
xticks(0:6:nDays*24)
xticklabels([])
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
ylabel('[G] (mg/dl)')

subplot(3,1,3)
hold on
try
    plot(const.times/60,const.Gin)
catch
    plot(time/60, [const.Gin const.Gin])
end
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlim([tMin 24*nDays])
xticks(0:6:nDays*24)
xticklabels(0:6:nDays*24)
xlabel('Time (h)')
ylabel('G_{in} (mg/min)')

%% Plot [G] and [I] (in % of baseline units) vs t for all 3 models.
figure()
% Plot [I]
subplot(nRows,nCol,N)
hold on
plot(tSt/60, utils.meanPercent(Ip, 1440))
plot(tStC/60,utils.meanPercent(IpC, 1440),'LineWidth',1)
title(pltTitle)
hold off
ylabel('[I] (%)')
legend('Original', 'New')
xlim([tMin 24*nDays])
xticks(0:6:nDays*24)
xticklabels([])
% Plot [G]
subplot(nRows,nCol,N+nCol)
hold on
plot(tSt/60, utils.meanPercent(G, 1440))
plot(tStC/60, utils.meanPercent(GC, 1440),'LineWidth',1)
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
%xlabel('Time (days)')
ylabel('[G] (%)')
xlim([tMin 24*nDays])
xticks(0:6:nDays*24)
xticklabels([])
subplot(nRows,nCol,N+2*nCol)
hold on
plot(tSt/60, utils.meanPercent(ISR,1440),'LineWidth',1)
plot(tStC/60, utils.meanPercent(ISR_circ,1440),'LineWidth',1)
xlabel('Time (hours)')
ylabel('ISR (%)')
xlim([tMin 24*nDays])
xticks(0:6:nDays*24)
xticklabels(0:6:nDays*24)

%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off

%xlabel('Time (days)')
ylabel('ISR (%)')
