function EEs = calculateEEs(outputVariable, delta)
%% Given an array of one output variable, calculate the EEs
% InputVariavle, rows are trajectories, columns each new step. 1st column
% initial condition, and then increments one perameter per column.
% Depth is models (Li, sturis, Tolic)
% Output EEs, rows trajectories, paramaters columns, depth models.
EEs = (outputVariable(:, 2:end,:)-outputVariable(:,1:end-1,:))/delta;
end

