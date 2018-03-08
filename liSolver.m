function sol=liSolver(state, const, time)
%Script to solve the Li et al. (2006) two delay DDE model

% const = models.constants;
% const.Gin = 136;
% const.tau1 = 7;
% const.tau2 = 36;

% % Initial conditions
% state = [10500; % Glucose
%          30]; % Insulin

% Solve equations
opts = odeset('RelTol',1e-6);
sol = dde23(@(t,y,z) models.Li(t,y,z,const), [const.tau1, const.tau2], state, time, opts);
end
