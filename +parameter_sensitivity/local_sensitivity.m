% Note code requires MATLAB 2017a or higher
clear all;
tic()


%% Preliminaries
% Create Cell array with parameter nales
%paramList = cellstr(['C5   '; 'C2   '; 'C3   '; 'alpha']);
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
default.tpT = 4;

% Range and resolution of parameter values. Relative to default value.
step = 0.1;

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
%path = '../../simResults/paramExplore/sim05/';

path ='~/scratch/';

Si = zeros(length(paramList),3);
SiReturn = zeros(length(paramList),3);
SiReturnAmp = zeros(length(paramList),3);

%% Simulations
% Loop over parameters and then loop over parameter values.
for j=1:length(paramList)
    % Name of parameter
    param = char(paramList(j));
    % Loop over interesting parameter values
    
        % Import constants
        const = models.constants;
        % Change constants from default values
        const.tau1 = 7;
        const.tau2 = 36;
        const.td = 36;
        const.Gin = 0;
        
        % Select value of changing parameter
        const.(param) = default.(param);
        if string(param)=="alpha" || string(param)=="C5" || string(param)=="tp"
             const.(strcat(param,'T')) = default.(strcat(param,'T'));
        end
        
        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);



        % Vector of baseline values for Li, Sturis, Tolic
        baseLine1 = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];
        returnTime = [utils.baseline_return(solLi.x, solLi.y(1,:), tmin),...
                     utils.baseline_return(tSt, ySt(:,3), tmin),...
                     utils.baseline_return(tT, yT(:,3), tmin)];
        returnTimeAmplitude = [utils.baselineAmplitude(solLi.x, solLi.y(1,:), tmin),...
                     utils.baselineAmplitude(tSt, ySt(:,3), tmin),...
                     utils.baselineAmplitude(tT, yT(:,3), tmin)];
        

        const = models.constants;
        % Change constants from default values
        const.tau1 = 7;
        const.tau2 = 36;
        const.td = 36;
        const.Gin = 0;
        
        % Select value of changing parameter
        const.(param) = default.(param)+default.(param)*step;
        if string(param)=="alpha" || string(param)=="C5" || string(param)=="tp"
             const.(strcat(param,'T')) = default.(strcat(param,'T')) + ...
                                         default.(strcat(param,'T'))*step;
        end
        
        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);

                
        baseLine2 = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];
        returnTime2 = [utils.baseline_return(solLi.x, solLi.y(1,:), tmin),...
                     utils.baseline_return(tSt, ySt(:,3), tmin),...
                     utils.baseline_return(tT, yT(:,3), tmin)];
        returnTimeAmplitude2 = [utils.baselineAmplitude(solLi.x, solLi.y(1,:), tmin),...
                     utils.baselineAmplitude(tSt, ySt(:,3), tmin),...
                     utils.baselineAmplitude(tT, yT(:,3), tmin)];
        
        Si(j,:) = (baseLine2-baseLine1)./step;
        SiReturn(j,:) = (returnTime2-returnTime)./step;
        SiReturnAmp(j,:) = (returnTimeAmplitude2-returnTimeAmplitude)./step;
end

%%
order = [16 8 10 11 17 18 12 13 19 14 9 15 20 1:4];
SiReturn = SiReturn(order,:);

%%
paramListSorted = paramList(order);

%%
paramPlot = categorical(paramList);
%Si = Si;%/max(max(Si));
figure()
bar(categorical(paramList), Si)
xlabel('Parameter')
ylabel('S_i')
legend('Li', 'Sturis', 'Tolic')

%%
figure()
bar(SiReturn)
xticks(1:length(paramListSorted))
xticklabels(paramListSorted)

xlabel('Parameter')
ylabel('S_i Return time')
legend('Li', 'Sturis', 'Tolic')

%%
figure()
bar(categorical(paramList), SiReturnAmp)
xlabel('Parameter')
ylabel('S_i Return time ampltiude')
legend('Li', 'Sturis', 'Tolic')