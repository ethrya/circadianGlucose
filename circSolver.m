clear;
%% Preliminaries
nDays = 3;
deltaT = 0.5;
% Import constants class
const = models.constants;

%Change constants from default values
[const.times, const.Gin] = protocols.IdenticalMeals(50, nDays, deltaT);
%%
%const.Gin = 0;
%const.C1 = 1720; const.Rm = 127.7; const.a1 = 464.4;

const.g = 0;
const.phi0 = 0;

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

ySt = utils.rk4Fixed(@models.sturis, sturisState, const, tSt);
%const.C1 = 1720; const.Rm = 127.7; const.a1 = 464.4;
%const.C5 = 18.6; const.Rg = 181.5; const.alpha = 0.1168;
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
plot(tSt/60,Ip)
plot(tStC/60,IpC)
hold off
ylabel('Insulin (\muU/ml)')
legend('Original', 'New')
% Plot [G]
subplot(3,1,2)
hold on
plot(tSt/60,G)
plot(tStC/60,GC)
%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlabel('Time (h)')
ylabel('Glucose (mg/dl)')

subplot(3,1,3)
hold on
try
    plot(const.times/60,const.Gin)
catch
    plot(time, [const.Gin const.Gin])
end

%plot([0 max(tT)/60], [mean(solLi.y(1,solLi.x>600)) mean(solLi.y(1,solLi.x>600))]/(10*const.Vg))
hold off
xlabel('Time (h)')
ylabel('G_{in} (mg/min)')

%% Phase plane
% Plot phase plane of I vs G for three models
figure
hold on
plot(G, Ip, 'LineWidth', 1.5)
plot(GC, IpC, 'LineWidth', 1.5)
xlabel('[G] (mg/dl)')
ylabel('[I_p] (\muU/ml)')
legend('Original', 'New')
hold off

%% Periodogram
[freqSC, P1] = periods.ft_solution(tStC, yStC, 1440);
figure;
plot(freqSC, P1)
xlabel('Frequency (1/min)')
ylabel('Power')