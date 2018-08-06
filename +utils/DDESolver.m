function sol=DDESolver(model, state, const, time)
%Script to solve the Li et al. (2006) two delay DDE model


% Solve equations
opts = odeset('RelTol',1e-6);
sol = dde23(@(t,y,z) model(t,y,z,const), [const.tau1, const.tau2], state, time, opts);
end
