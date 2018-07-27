%% Simulation of glucose clamp study in Brody
%% prelimaries
clear
tic
const = models.constants;
const.g1 = 0.05;
const.phi1 = 0;

const.clamp = 1; % Set glucose clamp

% G clamp values used in Brody (5mM, 8.8mM, 12.6mM)
gValues = [10000 16000 22700];

% Integration time (min)
time = [0, 1440*2.5];

%% Baseline Simulations
tSt = 0:1440*2.5; tStC = 0:1440*2.5;

figure()
hold on
for clampedG = 1:length(gValues)
    % Initial condition for Sturis and Tolic
    sturisState = [40; % Ip
        40; % Ii
        gValues(clampedG); % G
        0; % x1
        0; % x2
        0]; % x3
    
    yStC = utils.rk4Fixed(@models.sturisCirc, sturisState, const, tSt);
    
    %% Calculate ISR
    const.C = 2*pi*tStC'/1440;
    ISR_circ = models.funcs.f1(yStC(:,3),const);
    
    %% plot ISR
    plot(tStC/60, utils.meanPercent(ISR_circ,1440, 2*1440))
end

legend(num2str(gValues(1)), num2str(gValues(2)), num2str(gValues(3)))
xlabel('time (h)')
ylabel('ISR (%)')
xticks(24:4:48)
xticklabels(0:4:24)
xlim([24 48])
%% Printout statistics
toc