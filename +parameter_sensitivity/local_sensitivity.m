% Note code requires MATLAB 2017a or higher
clear all;
tic()


%% Preliminaries
% Create Cell array with parameter nales
paramList = cellstr(['C5   '; 'C2   '; 'C3   '; 'alpha']);
%paramList = cellstr(['Vp   '; 'Vi   '; 'Vg   '; 'E    '; 'tp   ';...
%                     'ti   '; 'td   '; 'Rm   '; 'Rg   '; 'a1   ';...
%                     'Ub   '; 'U0   '; 'Um   '; 'beta '; 'alpha';...
%                     'C1   '; 'C2   '; 'C3   '; 'C4   '; 'C5   ']);


% Default paramter values
default.Vp = 3; default.Vi = 11; default.Vg = 10; default.E = 0.3; 
default.tp = 6; default.ti = 100; default.td=36; 
default.Rm = 210; default.Rg = 180;
default.a1 = 300; 
default.Ub = 72; default.U0 = 40; default.Um = 940;
default.beta = 1.77; default.alpha = 0.29;
default.C1 = 2000; default.C2 = 144; default.C3 = 1000; default.C4 = 80;
default.C5 = 26; default.C5T = 29; default.alphaT = 0.41;

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

Sj = zeros(length(paramList),3);

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
        if string(param)=="alpha" || string(param)=="C5"
             const.(strcat(param,'T')) = default.(strcat(param,'T'));
        end
        
        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);



        % Vector of baseline values for Li, Sturis, Tolic
        baseLine1 = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];

        const = models.constants;
        % Change constants from default values
        const.tau1 = 7;
        const.tau2 = 36;
        const.td = 36;
        const.Gin = 0;
        
        % Select value of changing parameter
        const.(param) = default.(param)+default.(param)*step;
        if string(param)=="alpha" || string(param)=="C5"
             const.(strcat(param,'T')) = default.(strcat(param,'T')) + ...
                                         default.(strcat(param,'T'))*step;
        end
        
        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);

                
        baseLine2 = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];
        Si(j,:) = (baseLine2-baseLine1)./step;      
end

%%

Si = Si;%/max(max(Si));
figure()
bar(categorical(paramList), Si)
xlabel('Parameter')
ylabel('S_i')
legend('Li', 'Sturis', 'Tolic')