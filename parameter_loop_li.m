clear all;
tic()


%% Preliminaries
% Create Cell array with parameter nales
%paramList = cellstr(['C1   '; 'C2   '; 'C3   '; 'alpha']);
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

minV = 0.25; maxV = 1.75; step = 0.25;
relativeValues = minV:step:maxV;

% Initial conditions
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

warning('off', 'MATLAB:mir_warning_maybe_uninitialized_temporary');

path = '../simResults/paramExplore/test/';

%path ='~/scratch/';

poolobj = parpool(10);

%% Simulations

for j=1:length(paramList)
    param = char(paramList(j));
    paramValues = minV*default.(param):default.(param)*step:maxV*default.(param);
    fprintf('Simulating %s \n', param)
    return1 = zeros(length(paramValues), 3);
    return2 = zeros(length(paramValues), 3);
    baseLines = zeros(length(paramValues), 3);
    
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
        
          
        belowBaseIdxLi = find(solLi.y(1,:)-baseLines(i,1)<0.01*abs(baseLines(i,1)));
        belowBaseIdxSturis = find(ySt(:,3)-baseLines(i,2)<0.01*abs(baseLines(i,2)));
        belowBaseIdxTolic = find(yT(:,3)-baseLines(i,3)<0.01*abs(baseLines(i,3)));

        [peakLi, locLi] = findpeaks(-solLi.y(1,:), solLi.x, 'MinPeakProminence', 2);
        try
            aboveBaseIdxLi = find(solLi.y(1,:)>baseLines(i,1) & solLi.x>locLi(1));
        catch 
            aboveBaseIdxLi = [1];
        end

        [peakSt, locSt] = findpeaks(-ySt(:,3), tSt, 'MinPeakProminence', 2);
        try
            aboveBaseIdxSturis = find(ySt(:,3)>baseLines(i,2) & tSt>locSt(1));
        catch 
            aboveBaseIdxSturis = [1];
        end

        [peakTl, locTl] = findpeaks(-yT(:,3), tT, 'MinPeakProminence', 2);
        try
            aboveBaseIdxTolic = find(yT(:,3)>baseLines(i,3) & tT>locSt(1));
        catch 
            aboveBaseIdxTolic = [1];
        end

        return1(i, :) = [solLi.x(belowBaseIdxLi(1)), tSt(belowBaseIdxSturis(1))...
                         tT(belowBaseIdxTolic(1))];
        return2(i, :) = [solLi.x(aboveBaseIdxLi(1)), tSt(aboveBaseIdxSturis(1)),...
                         tT(aboveBaseIdxTolic(1))];
    end

    %% Plotting
    h = figure();
    hold on
    % Plot of 1st return to baseline [G]
    subplot(3,1,1)
    plot(relativeValues, return1)
    ylabel('t_{R,1} (min)')
    xlim([relativeValues(1) relativeValues(end)])
    legend('Li', 'Sturis', 'Tolic')    
    
    % Plot of 2nd return time to baseline [G]
    subplot(3,1,2)
    plot(relativeValues, return2)
    ylabel('t_{R,2} (min)')
    xlim([relativeValues(1) relativeValues(end)])
    
    % Plot of baseline [G]
    subplot(3,1,3)
    plot(relativeValues, baseLines./100)
    ylabel('[G]_B (mg/ml)')
    xlabel(param)
    xlim([relativeValues(1) relativeValues(end)])
    
    % Save figure as .fig and .png
    savefig(h, strcat(path, param))
    saveas(h, strcat(path, param, '.png'))
    
    % Save data
    parsave(strcat(path, param, '.mat'), return1, return2, baseLines)
end
toc()

delete(poolobj)

%% Function to save variables inside parfor loop
function parsave(fname, return1, return2, baseLines) %#ok<INUSD>
save(fname, 'return1', 'return2', 'baseLines')
end