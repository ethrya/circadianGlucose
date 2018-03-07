% Program to simulate the Sturis et al. 1991 model

%% Preliminaries
% Import constants file
const = models.constants;

% Change constants here
const.td = 36;
const.Gin = 216;

% Create initial condition
state = [30; % Ip
         0; % Ii
         13000; % G
         0; % x1
         0; % x2
         0]; % x3

%% Solve ODE using stiff solver
[t, y] = ode15s(@(t,y) models.sturis(t, y, const), [0,1400], state);


%% Plot output
% Convert values to concentrations
Ip = y(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = y(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl

subplot(2,1,1)
plot(t,Ip)
axis([0, 1400, 0, 50])
ylabel('Insulin (\muU/ml)')
subplot(2,1,2)
plot(t,G)
xlabel('Time (min)')
ylabel('Glucose (mg/dl)')