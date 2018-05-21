% Program to simulate the Sturis et al. 1991 model
function [t, y] = sturisSolver(state, const, time)

%% Solve ODE using stiff solver
opts = odeset('RelTol',1e-13, 'AbsTol', 1e-14);
[t, y] = ode113(@(t,y) models.sturis(t, y, const), time, state, opts);

end