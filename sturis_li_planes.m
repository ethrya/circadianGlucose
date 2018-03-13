const = models.constants;
const.tau1 = 7;
const.tau2 = 36;
const.td = 36;
const.Gin = 300;


state0s = [13000 30; 10000 30; 9000 70; 12500 26];

figure
hold on

for i=1:length(state0s(:,1))
% Initial conditions
liState = [state0s(i,1); % Glucose
         state0s(i,2)]; % Insulin

%% Preliminaries
% Change constants here

% Create initial condition
sturisState = [state0s(i,2); % Ip
               0; % Ii
               state0s(i,1); % G
               0; % x1
               0; % x2
               0]; % x3

time = [0, 2000];
           
sol = liSolver(liState, const, time);
[t, y] = sturisSolver(sturisState, const, time);

Ip = y(:,1)/const.Vp; %[I]=I/Vp microU/ml
G = y(:,3)/(const.Vg*10); %[G]=G/Vg mg/dl



plot(sol.y(1,:)/(10*const.Vg), sol.y(2,:)/const.Vp, 'b')
plot(G, Ip, 'r')
end
xlabel('Glucose (mg/dl)')
ylabel('Insulin (\muU/ml)')

legend('Li et al. 2006', 'Sturis et al. (1991)')