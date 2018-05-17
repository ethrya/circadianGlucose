clear all;
tic()


%% Preliminaries
% Create Cell array with parameter nales
%paramList = cellstr(['C1   '; 'C3   '; 'alpha']);
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
default.C5 = 26;

% Range and resolution of parameter values. Relative to default value.
minV = 0.50; maxV = 1.50; step = 0.05;
relativeValues = minV:step:maxV;

% Initial conditions for Li
liState = [14000; % Glucose
         40]; % Insulin

% Initial condition for Sturis and Tolic
sturisState = [40; % Ip
               0; % Ii
               14000; % G
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
%path = '../simResults/paramExplore/sim07/';
path ='../scratch/';
%path = 'C:\Users\ethan\scratch\';

% Create Parallel pool with 10 workers.
poolobj = parpool(10);

%% Simulations
% Loop over parameters and then loop over parameter values.
parfor j=1:length(paramList)
    % Name of parameter
    param = char(paramList(j));
    % Create vector of parameter values of interest using min/max fraction
    paramValues = minV*default.(param):default.(param)*step:maxV*default.(param);
    fprintf('Simulating %s \n', param)
    
    % Empty results vectors
    return1 = zeros(length(paramValues), 3);
    baseLines = zeros(length(paramValues), 3);
    baseLinesI = zeros(length(paramValues), 3);
    maxG = zeros(length(paramValues), 3);
    returnAmp = zeros(length(paramValues), 3);
    
    % Loop over interesting parameter values
    for i=1:length(paramValues)
        % Import constants
        const = models.constants;
        % Change constants from default values
        const.tau1 = 7;
        const.tau2 = 36;
        const.td = 36;
        const.Gin = 0;
        
        % Select value of changing parameter
        const.(param)= paramValues(i);

        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);

        % Vector of baseline values for Li, Sturis, Tolic
        baseLines(i,:) = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];
        baseLinesI(i,:) = [mean(solLi.y(2, solLi.x>tmin)), mean(ySt(tSt>tmin, 1)),...
                    mean(yT(tT>tmin, 1))];
        
        % Find peak [G] in all models.
        maxG(i,:) = [max(solLi.y(1,:)) max(ySt(:,3)) max(yT(:,3))];
        
        
        return1(i,:) = [utils.baseline_return(solLi.x, solLi.y(1,:), tmin),...
                     utils.baseline_return(tSt, ySt(:,3), tmin),...
                     utils.baseline_return(tT, yT(:,3), tmin)];
        returnAmp(i,:) = [utils.baselineAmplitude(solLi.x, solLi.y(1,:), tmin),...
                     utils.baselineAmplitude(tSt, ySt(:,3), tmin),...
                     utils.baselineAmplitude(tT, yT(:,3), tmin)];
    end

    %% Plotting
    h = figure();
    hold on
    % Plot of 1st return to baseline [G]
    subplot(5,1,1)
    plot(relativeValues, return1)
    ylabel('t_{R,1} (min)')
    xlim([relativeValues(1) relativeValues(end)])
    legend('Li', 'Sturis', 'Tolic')    
    
    % Plot of 1st return to baseline [G]
    subplot(5,1,2)
    plot(relativeValues, returnAmp)
    ylabel('t_{R,A} (min)')
    xlim([relativeValues(1) relativeValues(end)])
    
    % Plot of 2nd return time to baseline [G]
    subplot(5,1,3)
    plot(relativeValues, maxG./100)
    ylabel('[G]_{max} (mg/ml)')
    xlim([relativeValues(1) relativeValues(end)])
    
    % Plot of baseline [G]
    subplot(5,1,4)
    plot(relativeValues, baseLines./100)
    ylabel('[G]_B (mg/ml)')
    xlabel(param)
    xlim([relativeValues(1) relativeValues(end)])
    
    % Plot of baseline [I]
    subplot(5,1,5)
    plot(relativeValues, baseLinesI./const.Vp)
    ylabel('[I]_B (mU/\mu L)')
    xlabel(param)
    xlim([relativeValues(1) relativeValues(end)])
    
    % Save figure as .fig and .png
    savefig(h, strcat(path, param))
    saveas(h, strcat(path, param, '.png'))
    
    % Save data
    parsave(strcat(path, param, '_test.mat'), return1, maxG, baseLines, baseLinesI)
end
toc()

% Remoove parallel pool
delete(poolobj)

%% Function to save variables inside parfor loop
function parsave(fname, return1, maxG, baseLines, baseLinesI) %#ok<INUSD>
save(fname, 'return1', 'maxG', 'baseLines', 'baseLinesI')
end
