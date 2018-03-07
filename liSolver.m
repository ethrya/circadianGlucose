%Script to solve the Li et al. (2006) two delay DDE model

const = models.constants;

% Initial conditions
state = [10500; % Glucose
         30]; % Insulin

% Solve equations
sol = dde23(@models.Li, [const.tau1, const.tau2], state, [0,1000]);

subplot(2,1,1)
plot(sol.x, sol.y(2,:)/const.Vp)
ylabel('Insulin (\muU/ml)')
subplot(2,1,2)
plot(sol.x, sol.y(1,:)/(10*const.Vg));
xlabel('Time (min)')
ylabel('Glucose (mg/dl)')