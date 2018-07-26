%% Circadian Model test
% Run a test of the current model with baseline glucose and create a meal
% response curve
%% prelimaries
clear
tic
const = models.constants;
const.g1 = 0.2;
const.phi1 = 0;
const.g2 = 0;
const.phi2 = 0;
const.g3 = 0.2;
const.phi3 = -pi/2;

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
const.Gin = 50;

tSt = 0:1440*2.5; tStC = 0:1440*2.5;

ySt = utils.rk4Fixed(@models.sturis, sturisState, const, tSt);

yStC = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tSt);

%% Calculate ISR
ISR = models.funcs.f1(ySt(:,3),const);
const.C = 2*pi*tStC'/1440;
ISR_circ = models.funcs.f1(yStC(:,3),const);

% Plots
%% Plot [G] and [I] (in % of baseline units) vs t for all 3 models.
% Convert glucose amounts into concentrations
Ip = ySt(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = ySt(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl
IpC = yStC(:,1)/const.Vp; %[I]=I/Vp microU/ml
GC = yStC(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

figure()
% Plot [I]
subplot(4,1,1)
utils.plots.plotDay(tSt,Ip,tStC,IpC,'[I] (% of mean)')
legend('Original', 'Circadian')

% Plot [G]
subplot(4,1,2)
utils.plots.plotDay(tSt,G,tStC, GC,'[G] (% of mean)')

% Plot ISR f1
subplot(4,1,3)
utils.plots.plotDay(tSt,ISR,tStC,ISR_circ,'ISR (% of mean)')

%% Tolerance
subplot(4,1,4)
protocols.tolerance_rc(const, 4);

toc