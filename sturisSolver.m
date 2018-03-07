% Program to simulate the Sturis et al. 1991 model

% Create initial condition
state = [30; % Ip
         30; % Ii
         10500; % G
         30; % x1
         30; % x2
         30]; % x3
     
[t, y] = ode15s(@models.sturis, [0,600], state);


% Convert values to concentrations
Ip = y(:,1)/models.constants.Vp; %[I]=I/Vp microU/ml
G = y(:,3)/(models.constants.Vg*10); %[G]=G/Vg mg/dl

subplot(2,1,1)
plot(t,Ip)
ylabel('Insulin (\muU/ml)')
subplot(2,1,2)
plot(t,G)
xlabel('Time (min)')
ylabel('Glucose (mg/dl)')