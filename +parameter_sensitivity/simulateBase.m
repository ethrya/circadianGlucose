function [baseG, baseI] = simulateBase(const,paramList,parDelta,path,I0,G0,nSims)
% Function to calculate baseline for multiple paramater values
% Inputs:
% Const- class of constants
% paramList  - Structure of paramaters
% parDelta - a nxm array of paramater values n number of paramaers, m nsims

% Initial conditions for Li
liState = [G0; % Glucose
    I0]; % Insulin

% Initial condition for Sturis and Tolic
sturisState = [I0; % Ip
    I0; % Ii
    G0; % G
    0; % x1
    0; % x2
    0]; % x3

time = [0 5000];
tmin = 3000;

baseG = zeros(nSims, 3, 'single'); baseI= zeros(nSims, 3,'single');

nSims = size(parDelta,2);
for i=1:nSims
    % Create new constant class with default values
    constSim = const;
    % Update Constant values for simulation run
    for j=1:length(paramList)
        % Name of parameter
        param = char(paramList(j));
        % Select value of changing parameter
        constSim.(param) = constSim.(param)+parDelta(j,i)*constSim.(param);
    end
    % Solve equations
    solLi = liSolver(liState, constSim, time);
    [tSt, ySt] = ODESolver(@models.sturis, sturisState, constSim, time);
    [tT, yT] = ODESolver(@models.tolic, sturisState, constSim, time);
    
    % Save simulation results
    utils.save_Sim(solLi,tSt, ySt, tT, yT, constSim,...
        strcat(path,num2str(i.','%03d')));
    
    % Vector of baseline values for Li, Sturis, Tolic
    baseG(i,:) = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
        mean(yT(tT>tmin, 3))];
    baseI(i,:) = [mean(solLi.y(2, solLi.x>tmin)), mean(ySt(tSt>tmin, 1)),...
        mean(yT(tT>tmin, 1))];
end
end