clear all;
const = models.constants;
const.tau1 = 7;
const.tau2 = 36;
const.td = 36;
const.Gin = 0;

const.C3 = 900;
%const.tp = 4;
%const.alpha = 0.41;

tmin = 3000;

% Initial conditions
liState = [15000; % Glucose
         30]; % Insulin

%% Preliminaries
% Change constants here

% Create initial condition
sturisState = [30; % Ip
               0; % Ii
               15000; % G
               0; % x1
               0; % x2
               0]; % x3

time = [0, 5000];
           
sol = liSolver(liState, const, time);
[t, y] = sturisSolver(sturisState, const, time);
[tT, yT] = tolicSolver(sturisState, const, time);

Ip = y(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = y(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

subplot(2,1,1)
hold on
plot(sol.x, sol.y(2,:)/const.Vp)
plot(t,Ip)
plot(tT, yT(:,1)/const.Vp)
hold off
ylabel('Insulin (\muU/ml)')
legend('Li et al. (2006)', 'Sturis et al. (1991)', 'Tolic et al. (2000)')
subplot(2,1,2)
hold on
plot(sol.x, sol.y(1,:)/(10*const.Vg));
plot(t,G)
plot(tT, yT(:,3)/(10*const.Vg))
hold off
xlabel('Time (min)')
ylabel('Glucose (mg/dl)')

figure
hold on
plot(sol.y(1,:)/(10*const.Vg), sol.y(2,:)/const.Vp)
plot(G, Ip)
plot(yT(:,3)/(10*const.Vg), yT(:,1)/const.Vp)
legend('Li et al. (2006)', 'Sturis et al. (1991)', 'Tolic et al. (2000)')
hold off