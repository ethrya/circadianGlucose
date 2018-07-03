function [t, y] = ODESolver(model, state, const, time)
% Wrapper of ODE solver for either the Sturis or Tolic models.
% Inputs:
% model - model as function of t, yIn, and const.
% state - initial State vector
% const - constants class
% time - vector of times
% OUTPUTS:
% t - times corresponding to solutions
% y - array containing values of solutions at times t
%% Solve ODE using stiff solver
opts = odeset('RelTol',1e-13, 'AbsTol', 1e-14);
[t, y] = ode45(@(t,y) model(t, y, const), time, state, opts);

end