%% Circadian Model test
% Run a test of the current model with baseline glucose and create a meal
% response curve
%% prelimaries
tic
const = models.constants;
const.g1 = 0.1;
const.phi1 = -3*pi/4;
const.g2 = 0;
const.phi2 = -3*pi/4;

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
subplot(3,1,1)
hold on
plot(tSt/60, utils.meanPercent(Ip, 1440))
plot(tStC/60,utils.meanPercent(IpC, 1440),'k')
hold off
ylabel('[I] (% of mean)')
legend('Original', 'Circadian')
xticks([24:4:48])
xticklabels([0:4:24])
xlim([24 48])

% Plot [G]
subplot(3,1,2)
hold on
plot(tSt/60, utils.meanPercent(G, 1440))
plot(tStC/60, utils.meanPercent(GC, 1440),'k')
hold off
xlabel('Time (hours)')
ylabel('[G] (% of mean)')
xticks([24:4:48])
xticklabels([0:4:24])
xlim([24 48])

%% Tolerance
subplot(3,1,3)
protocols.tolerance_rc(const, 2);

toc