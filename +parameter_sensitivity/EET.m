%% Note code requires MATLAB 2017a or higher
clear
tic
%% Preliminaries
% Create Cell array with parameter nales
%paramList = cellstr(['C1   '; 'C2   ']);%; 'C3   '; 'alpha']);
paramList = cellstr(['Vp   '; 'Vi   '; 'Vg   '; 'E    '; 'tp   ';...
                   'ti   '; 'td   '; 'Rm   '; 'Rg   '; 'a1   ';...
                   'Ub   '; 'U0   '; 'Um   '; 'beta '; 'alpha';...
                   'C1   '; 'C2   '; 'C3   '; 'C4   '; 'C5   ']);


% Default paramter values
default.Vp = 3; default.Vi = 11; default.Vg = 10; default.E = 0.3;
default.tp = 6; default.ti = 100; default.td=36;
default.Rm = 210; default.Rg = 180;
default.a1 = 300;
default.Ub = 72; default.U0 = 40; default.Um = 940;
default.beta = 1.77; default.alpha = 0.29;
default.C1 = 2000; default.C2 = 144; default.C3 = 1000; default.C4 = 80;
default.C5 = 26; default.C5T = 29; default.alphaT = 0.41;

% Define parameter space
k = length(paramList); % Number of parameters
p = 4; % Number of levels
r = 100; % Number of trajectories
c = 0.1; % fraction of default value to sample (e.g. c=0.2 => [0.8,1.2])
delta = 2*c/p; % spacing of trajectories

runNo = 2;

% Initial conditions for Liz
liState = [20000; % Glucose
    40]; % Insulin


% Initial condition for Sturis and Tolic
sturisState = [40; % Ip
    40; % Ii
    20000; % G
    0; % x1
    0; % x2
    0]; % x3

% Simulation start and end times
time = [0, 5000];
% Time to start measuring baseline [G] from
tmin = 3000;

% Don't warn about temporary variables in parfor loop. This should return a
% run-time error if there is an issue.
warning('off', 'MATLAB:mir_warning_maybe_uninitialized_temporary');

% Path to results output
%path = '../../simResults/paramExplore/sim05/';

path ='~/scratch/';

Sj = zeros(length(paramList),3);

EEs = zeros(k, r, 3);
EEsReturnTime  = zeros(k, r, 3);
EEsReturnAmplitude  = zeros(k, r, 3);
%% Simulations
% Loop over trajectories then parameters and then loop over parameter values.
for i=1:r
    fprintf('Completing trajectory %i of %i \n', i, r);
    % Import constants
    const = models.constants;
    % Change constants from default values
    const.tau1 = 7;
    const.tau2 = 36;
    const.td = 36;
    const.Gin = 0;
    
    % Compute initial parameter values
    % Choose discrete values on U[1, p+1]
    randNum = unidrnd(p, [k 1]);
    % Convert from U[0, p+1] to U[-c, c-delta]
    noise = 2*c/p*(randNum-1)-c;
    % Update initial parameter values
    for j=1:length(paramList)
        % Name of parameter
        param = char(paramList(j));
        % Loop over interesting parameter values
        
        % Select value of changing parameter
        const.(param) = default.(param)*(1+noise(j));
        if string(param)=="alpha" || string(param)=="C5"
            const.(strcat(param,'T')) = default.(strcat(param,'T'))*(1+...
                                        noise(j));
        end
    end
    
    % Solve equations
    solLi = liSolver(liState, const, time);
    [tSt, ySt] = sturisSolver(sturisState, const, time);
    [tT, yT] = tolicSolver(sturisState, const, time);

    
    % Vector of baseline values for Li, Sturis, Tolic
    baseLineOld = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
        mean(yT(tT>tmin, 3))];
    returnTimeOld = [utils.baseline_return(solLi.x, solLi.y(1,:), tmin),...
                     utils.baseline_return(tSt, ySt(:,3), tmin),...
                     utils.baseline_return(tT, yT(:,3), tmin)];
%     returnAmplitudeOld = [utils.baselineAmplitude(solLi.x, solLi.y(1,:), tmin),...
%                      utils.baselineAmplitude(tSt, ySt(:,3), tmin),...
%                      utils.baselineAmplitude(tT, yT(:,3), tmin)];
    returnAmplitudeOld = [log(20)/utils.expon_fit(solLi.x, solLi.y(1,:), tmin).b,...
                          log(20)/utils.expon_fit(tSt, ySt(:,3), tmin).b,...
                          log(20)/utils.expon_fit(tT, yT(:,3), tmin).b];
    
    utils.save_Sim(solLi,tSt, ySt, tT, yT, const, outStr(date, runNo, i, 0));
                   
    for j=1:k
        % Name of parameter
        param = char(paramList(j));
        % Loop over interesting parameter values
        
        % Select value of changing parameter
        const.(param) = const.(param)*(1 + delta);
        if string(param)=="alpha" || string(param)=="C5"
            const.(strcat(param,'T')) = default.(strcat(param,'T'))*(1+delta);
        end
        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);
        
        baseLine = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];
        returnTime = [utils.baseline_return(solLi.x, solLi.y(1,:), tmin),...
                     utils.baseline_return(tSt, ySt(:,3), tmin),...
                     utils.baseline_return(tT, yT(:,3), tmin)];
        returnTimeAmplitude = [log(20)/utils.expon_fit(solLi.x, solLi.y(1,:), tmin).b,...
                          log(20)/utils.expon_fit(tSt, ySt(:,3), tmin).b,...
                          log(20)/utils.expon_fit(tT, yT(:,3), tmin).b];
        
        
        EEs(j,i,:) = (baseLine-baseLineOld)/(delta);
        
        EEsReturnTime(j,i,:) = (returnTime-returnTimeOld)/(delta);
        EEsReturnAmplitude(j,i,:) = (returnTimeAmplitude-returnAmplitudeOld)/(delta);
        
        baseLineOld=baseLine;
        returnTimeOld=returnTime; returnAmplitudeOld=returnTimeAmplitude;
                   
        utils.save_Sim(solLi,tSt, ySt, tT, yT, const, outStr(date, runNo, i, j));

    end
end


%%
%%
%% [G]_B
[muStarGb, muGb, sigmaGb] = parameter_sensitivity.EET_means(EEs, k);
parameter_sensitivity.plot_EET(paramList, muStarGb, sigmaGb)
%% mean life
[muStarTau, muTau, sigmaTau] = parameter_sensitivity.EET_means(EEsReturnAmplitude, k);
parameter_sensitivity.plot_EET(paramList, muStarTau, sigmaTau)

%% t1 Return time
[muStarT1, muT1, sigmaT1] = parameter_sensitivity.EET_means(EEsReturnTime, k);
parameter_sensitivity.plot_EET(paramList, muStarT1, sigmaT1)
toc

%% Function to create path for saving
function path = outStr(date, runNo, i, j)
    formatOut = 'yyyy-mm-dd';
    dateForm = datestr(date, formatOut);
    path = strcat("../simResults/",dateForm,"/run_", num2str(runNo.','%02d'),...
        "/i-",num2str(i.','%03d'),"_j-",num2str(j.','%03d'));
end
