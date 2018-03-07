%Script to solve the Li et al. (2006) two delay DDE model

const = models.constants;
const.Gin = 108;
const.tau1 = 7;
const.tau2 = 12;

% Initial conditions
state = [10500; % Glucose
         30]; % Insulin

% Solve equations
opts = odeset('RelTol',1e-6);
sol = dde23(@(t,y,z) models.Li(t,y,z,const), [const.tau1, const.tau2], state, [0,1500]);

subplot(2,1,1)
plot(sol.x, sol.y(2,:)/const.Vp)
ylabel('Insulin (\muU/ml)')
subplot(2,1,2)
plot(sol.x, sol.y(1,:)/(10*const.Vg));
xlabel('Time (min)')
ylabel('Glucose (mg/dl)')