%% Circadian Model test
% Run a test of the current model with baseline glucose and create a meal
% response curve
%% prelimaries
clear
tic
const = models.constants;
const.g1 = 0.02;
const.phi1 = 0;
const.g2 = 0.1;
const.phi2 = pi;
%const.g3 = 0.3;
%const.phi3 = 0;


% Initial condition for Li (G,  I)
IC = [10000 40];

% Integration time (min)
time = [0, 1440*2.5];

%% Baseline Simulations
const.Gin = 0;
%const.tau1 = 5; const.tau2 = 5;

tSt = 0:1440*2.5; tStC = 0:1440*2.5;
solLi = utils.DDESolver(@models.Li, IC, const, time);
solLiCirc = utils.DDESolver(@models.LiCirc, IC, const, time);

%% Calculate ISR
ISR = models.funcs.f1(solLi.y(1,:),const);
const.C = 2*pi*solLiCirc.x/1440;
ISR_circ = models.funcs.f1(solLiCirc.y(1,:),const);

% Plots
%% Plot [G] and [I] (in % of baseline units) vs t for all 3 models.
% Convert glucose amounts into concentrations
Ip = solLi.y(2,:)/const.Vp; %[I]=I/Vp microU/ml
G = solLi.y(1,:)/(const.Vg*10); %[G]=G/Vg mg/dl
IpC = solLiCirc.y(2,:)/const.Vp; %[I]=I/Vp microU/ml
GC = solLiCirc.y(1,:)/(const.Vg*10); %[G]=G/Vg mg/dl

tSt = solLi.x;
tStC = solLiCirc.x;

figure('name', 'Li Tests')
nPlots = 5;
% Plot [I]
subplot(nPlots,1,1)
utils.plots.plotDay(tSt,Ip,tStC,IpC,'[I] (%)')
legend('Original', 'Circadian')

% Plot [G]
subplot(nPlots,1,2)
utils.plots.plotDay(tSt,G,tStC, GC,'[G] (%)')

% Plot ISR f1
subplot(nPlots,1,3)
utils.plots.plotDay(tSt,ISR,tStC,ISR_circ,'ISR (%)')

%% Tolerance
[gPeak, gAUC, mealTimes] = protocols.tolerance_rc(const, 4);

%% Plot peak glucose vs meal time
subplot(nPlots,1,4)
plot(mealTimes, gPeak/100,'k')
ylabel('Peak [G] (mg/dl)')
xticks(0:4:24)
xticklabels(0:4:24)
xlim([0 24])

subplot(nPlots,1,5)
plot(mealTimes, gAUC/gAUC(1),'k')
xlabel('Meal Time (zt)')
ylabel('iAUC (A.U.)')
xticks(0:4:24)
xticklabels(0:4:24)
xlim([0 24])
%% Printout statistics
sprintf('Circadian [G]_b: %.2f (mg/dl)',mean(GC(tStC/60>24 &tStC/60<48)))
toc