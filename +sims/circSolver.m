clear;
%% Preliminaries
nDays = 2;
deltaT = 0.5;
% Import constants class
const = models.constants;

%Change constants from default values
%[const.times, const.Gin] = protocols.IdenticalMeals(50, nDays, deltaT);
%const.times = 0:deltaT:2*1440;
%const.Gin = protocols.saad12(deltaT);
%%
const.Gin = 0;

const.g1 = 0.3;
const.phi1 = 0;
const.g2 = 0;
const.phi2 = 0;
const.g3 = 0;
const.phi3 = 0;
%const.td = 5;
%const.E = 0.2;
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
tSt = 0:1440*nDays; tStC = 0:1440*nDays;

%const.C1 = 1720; const.Rm = 150; const.a1 = 350;
%const.C5 = 18.6; const.Rg = 181.5; const.alpha = 0.1168;
%const.Vg = 13.3; const.Vi = 3.15; const.Vp = 5;

ySt = utils.rk4Fixed(@models.sturis, sturisState, const, tSt);

yStC = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tSt);


%% Plotting
% Convert glucose amounts into concentrations
Ip = ySt(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = ySt(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl
IpC = yStC(:,1)/const.Vp; %[I]=I/Vp microU/ml
GC = yStC(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

% Plot [G] and [I] vs t for all 3 models.
figure()
% Plot [I]
subplot(3,1,1)
hold on
plot(tSt/60, Ip)
plot(tStC/60, IpC)
hold off
xlim([24 48])
xticks(0:6:48)
xticklabels(-24:6:24)
ylabel('[I] (\muU/ml)')
legend('Original', 'New')
% Plot [G]
subplot(3,1,2)
hold on
plot(tSt/60, G)
plot(tStC/60, GC)
xlim([24 48])
xticks(0:6:48)
xticklabels(-24:6:24)

%xticklabels(0:0.25:2)
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlabel('Clock Time')
ylabel('[G] (mg/dl)')

subplot(3,1,3)
hold on
try
    plot(const.times/1440,const.Gin)
catch
    plot(time/1440, [const.Gin const.Gin])
end
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlim([1 2])
xticks(1:0.25:2)
xticklabels(0:6:24)
xlabel('Clock Time')
ylabel('G_{in} (mg/min)')

%% Plot [G] and [I] (in % of baseline units) vs t for all 3 models.
figure()
% Plot [I]
subplot(3,1,1)
hold on
plot(tSt/60, utils.meanPercent(Ip, 1440))
plot(tStC/60,utils.meanPercent(IpC, 1440))
hold off
ylabel('[I] (% of mean)')
legend('Original', 'New')
xlim([24 48])
xticks(0:6:48)
xticklabels(-24:6:24)
% Plot [G]
subplot(3,1,2)
hold on
plot(tSt/60, utils.meanPercent(G, 1440))
plot(tStC/60, utils.meanPercent(GC, 1440))
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlabel('Time (days)')
ylabel('[G] (% of mean)')
xlim([24 48])
xticks(0:6:48)
xticklabels(-24:6:24)

subplot(3,1,3)
hold on
try
    plot(const.times/1440,const.Gin)
catch
    plot(time/1440, [const.Gin const.Gin])
end

%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlim([1 2])
xticks(1:0.25:2)
xticklabels(0:6:24)
xlabel('Time (days)')
ylabel('G_{in} (mg/min)')
