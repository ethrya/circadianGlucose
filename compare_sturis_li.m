clear all;
%% Preliminaries
% Import constants class
const = models.constants;

%Change constants from default values
const.tau1 = 7;
const.tau2 = 36;
const.td = 36;
const.Gin = 100;
%const.C3 = 550;
%const.tp = 4;
%const.alpha = 0.41;

% Initial conditions Li 
liState = [10000; % Glucose
         30]; % Insulin

% Initial condition Sturis and Tolic
sturisState = [30; % Ip
               0; % Ii
               10000; % G
               0; % x1
               0; % x2
               0]; % x3

% Integration time (min)
time = [0, 5000];
  

%% Solve equations
solLi = liSolver(liState, const, time);
[tSt, ySt] = sturisSolver(sturisState, const, time);
[tT, yT] = tolicSolver(sturisState, const, time);


%% Plotting
% Convert glucose amounts into concentrations (Sturis only)
Ip = ySt(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = ySt(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl


% Plot [G] and [I] vs t for all 3 models.
figure()
% Plot [G]
subplot(2,1,1)
hold on
plot(solLi.x, solLi.y(2,:)/const.Vp)
plot(tSt,Ip)
plot(tT, yT(:,1)/const.Vp)
hold off
ylabel('Insulin (\muU/ml)')
legend('Li et al. (2006)', 'Sturis et al. (1991)', 'Tolic et al. (2000)')
% Plot [I]
subplot(2,1,2)
hold on
plot(solLi.x, solLi.y(1,:)/(10*const.Vg));
plot(tSt,G)
plot(tT, yT(:,3)/(10*const.Vg))
hold off
xlabel('Time (min)')
ylabel('Glucose (mg/dl)')


%% Phase plane
% Plot phase plane of I vs G for three models
figure
hold on
plot(solLi.y(1,:)/(10*const.Vg), solLi.y(2,:)/const.Vp, 'LineWidth', 1.5)
plot(G, Ip, 'LineWidth', 1.5)
plot(yT(:,3)/(10*const.Vg), yT(:,1)/const.Vp, 'LineWidth', 1.5)
xlabel('[G] (mg/dl)')
ylabel('[I_p] (\muU/ml)')
legend('Li et al. (2006)', 'Sturis et al. (1991)', 'Tolic et al. (2000)')
hold off