%% Circadian Model test

%% prelimaries
const = models.constants;
const.g1 = 0;
const.g2 = 0.3;

% Initial condition for Sturis and Tolic
sturisState = [40; % Ip
    40; % Ii
    10000; % G
    0; % x1
    0; % x2
    0]; % x3

% Integration time (min)
time = [0, 1440*2.5];

%% Baseline Simulations
const.Gin = 0;

tSt = 0:1440*2.5; tStC = 0:1440*2.5;

ySt = utils.rk4Fixed(@models.sturis, sturisState, const, tSt);
%const.C1 = 1720; const.Rm = 150; const.a1 = 350;
%const.C5 = 18.6; const.Rg = 181.5; const.alpha = 0.1168;

yStC = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tSt);

% Plots
%% Plot [G] and [I] (in % of baseline units) vs t for all 3 models.
% Convert glucose amounts into concentrations
Ip = ySt(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = ySt(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl
IpC = yStC(:,1)/const.Vp; %[I]=I/Vp microU/ml
GC = yStC(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

figure()
% Plot [I]
subplot(2,1,1)
hold on
plot(tSt/60, utils.meanPercent(Ip, 1440))
plot(tStC/60,utils.meanPercent(IpC, 1440))
hold off
ylabel('[I] (% of mean)')
legend('Original', 'Standard')
xticks([24:4:48])
xticklabels([0:4:24])
xlim([24 48])
% Plot [G]
subplot(2,1,2)
hold on
plot(tSt/60, utils.meanPercent(G, 1440))
plot(tStC/60, utils.meanPercent(GC, 1440))
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlabel('Time (hours)')
ylabel('[G] (% of mean)')
xticks([24:4:48])
xticklabels([0:4:24])
xlim([24 48])

%% Tolerance
figure()
protocols.tolerance_rc(const, 2);
