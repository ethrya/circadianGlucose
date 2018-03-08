const = models.constants;
const.tau1 = 7;
const.tau2 = 12;
const.td = 12;
const.Gin = 135;


% Initial conditions
liState = [10500; % Glucose
         30]; % Insulin

%% Preliminaries
% Change constants here

% Create initial condition
sturisState = [30; % Ip
               0; % Ii
               10500; % G
               0; % x1
               0; % x2
               0]; % x3

time = [0, 10000];
           
sol = liSolver(liState, const, time);
[t, y] = sturisSolver(sturisState, const, time);

Ip = y(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = y(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

subplot(2,1,1)
hold on
plot(sol.x, sol.y(2,:)/const.Vp)
plot(t,Ip)
hold off
ylabel('Insulin (\muU/ml)')
subplot(2,1,2)
hold on
plot(sol.x, sol.y(1,:)/(10*const.Vg));
plot(t,G)
hold off
xlabel('Time (min)')
ylabel('Glucose (mg/dl)')

figure
hold on
plot(sol.y(1,:)/(10*const.Vg), sol.y(2,:)/const.Vp)
plot(G, Ip)
hold off