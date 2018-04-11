clear all;
tic()
%% Preliminaries
% Create Cell array with parameter nales
paramList = cellstr(['C1'; 'C2']);

% Create structure with corresponding parameter values
paramValues.C1 = 1000:500:3000;
paramValues.C2 = 74:40:214;

% Initial conditions
liState = [15000; % Glucose
         30]; % Insulin

% Initial condition for Sturis and Tolic
sturisState = [30; % Ip
               0; % Ii
               15000; % G
               0; % x1
               0; % x2
               0]; % x3

% Simulation start and end times
time = [0, 5000];
% Time to start measuring baseline [G] from
tmin = 3000;

warning('off', 'MATLAB:mir_warning_maybe_uninitialized_temporary');


for j=1:length(paramList)
    param = char(paramList(j));
    fprintf('Simulating %s \n', param)
    return1 = zeros(length(paramValues.(param)), 3);
    return2 = zeros(length(paramValues.(param)), 3);
    baseLines = zeros(length(paramValues.(param)), 3);
    
    for i=1:length(paramValues.(param))
        % Import constants
        const = models.constants;
        % Change constants from default values
        const.tau1 = 7;
        const.tau2 = 36;
        const.td = 36;
        const.Gin = 0;
        
        % Select value of changing parameter
        const.(param)= paramValues.(param)(i);

        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);

        % Vector of baseline values for Li, Sturis, Tolic
        baseLines(i,:) = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];

        belowBaseIdxLi = find(solLi.y(1,:)-baseLines(i,1)<0.01*baseLines(i,1));
        belowBaseIdxSturis = find(ySt(:,3)-baseLines(i,2)<0.01*baseLines(i,2));
        belowBaseIdxTolic = find(yT(:,3)-baseLines(i,3)<0.01*baseLines(i,3));

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
    subplot(3,1,1)
    plot(paramValues.(param), return1)
    ylabel('t_{R,1} (min)')
    xlim([paramValues.(param)(1) paramValues.(param)(end)])
    legend('Li', 'Sturis', 'Tolic')
    subplot(3,1,2)
    plot(paramValues.(param), return2)
    ylabel('t_{R,2} (min)')
    xlim([paramValues.(param)(1) paramValues.(param)(end)])
    subplot(3,1,3)
    plot(paramValues.(param), baseLines./100)
    ylabel('[G]_B (mg/ml)')
    xlabel('Paramter Value')
    xlim([paramValues.(param)(1) paramValues.(param)(end)])
    savefig(h, strcat('~/scratch/', param))
    saveas(h, strcat('~/scratch/', param, '.png'))

end
toc()