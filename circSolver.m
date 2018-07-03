clear;
%% Preliminaries
% Import constants class
const = models.constants;

%Change constants from default values
const.Gin =200;

const.g = 0.1;
const.phi0 = pi;
%const.tau2 = 10;
%const.Vg = 5;
%const.Vp = 5;

% Initial condition for Sturis and Tolic
sturisState = [40; % Ip
    40; % Ii
    10000; % G
    0; % x1
    0; % x2
    0]; % x3

% Integration time (min)
time = [0, 5000];
  

%% Solve equations
[tSt, ySt] = ODESolver(@models.sturis, sturisState, const, time);
[tStC, yStC] = ODESolver(@models.sturisCirc, sturisState, const, time);


%% Plotting
% Convert glucose amounts into concentrations
Ip = ySt(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = ySt(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl
IpC = yStC(:,1)/const.Vp; %[I]=I/Vp microU/ml
GC = yStC(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

% Plot [G] and [I] vs t for all 3 models.
figure()
% Plot [I]
subplot(2,1,1)
hold on
plot(tSt/60,Ip)
plot(tStC/60,IpC)
hold off
ylabel('Insulin (\muU/ml)')
legend('Normal', 'Circadian')
% Plot [G]
subplot(2,1,2)
hold on
plot(tSt/60,G)
plot(tStC/60,GC)
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlabel('Time (h)')
ylabel('Glucose (mg/dl)')


%% Phase plane
% Plot phase plane of I vs G for three models
figure
hold on
plot(G, Ip, 'LineWidth', 1.5)
plot(GC, IpC, 'LineWidth', 1.5)
xlabel('[G] (mg/dl)')
ylabel('[I_p] (\muU/ml)')
legend('Normal', 'Circadian')
hold off

%% Periodogram
periods.ft_solution()