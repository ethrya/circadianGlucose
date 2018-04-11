clear all;
tic()
%% Preliminaries
paramList = cellstr(['C1'; 'C2']);

paramValues.C1 = 1000:500:2000;
paramValues.C2 = 74:20:214;



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


for j=1:length(paramList)
    param = char(paramList(j));
    disp(
    return1 = zeros(length(paramValues.(param)), 3);
    return2= zeros(length(paramValues.(param)), 3);
    
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
        sol = liSolver(liState, const, time);
        [t, y] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);

        % Vector of baseline values for Li, Sturis, Tolic
        baseLines = [mean(sol.y(1, sol.x>tmin)), mean(y(t>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];

        belowBaseIdxLi = find(sol.y(1,:)-baseLines(1)<0.01*baseLines(1));
        belowBaseIdxSturis = find(y(:,3)-baseLines(2)<0.01*baseLines(2));
        belowBaseIdxTolic = find(yT(:,3)-baseLines(3)<0.01*baseLines(3));

        [peakLi, locLi] = findpeaks(-sol.y(1,:), sol.x, 'MinPeakProminence', 2);
        try
            aboveBaseIdxLi = find(sol.y(1,:)>baseLines(1) & sol.x>locLi(1));
        catch 
            aboveBaseIdxLi = [1];
        end

        [peakSt, locSt] = findpeaks(-y(:,3), t, 'MinPeakProminence', 2);
        try
            aboveBaseIdxSturis = find(y(:,3)>baseLines(2) & t>locSt(1));
        catch 
            aboveBaseIdxSturis = [1];
        end

        [peakTl, locTl] = findpeaks(-yT(:,3), tT, 'MinPeakProminence', 2);
        try
            aboveBaseIdxTolic = find(yT(:,3)>baseLines(3) & tT>locSt(1));
        catch 
            aboveBaseIdxTolic = [1];
        end


        return1(i, :) = [sol.x(belowBaseIdxLi(1)), t(belowBaseIdxSturis(1))...
                         tT(belowBaseIdxTolic(1))];
        return2(i, :) = [sol.x(aboveBaseIdxLi(1)), t(aboveBaseIdxSturis(1)),...
                         tT(aboveBaseIdxTolic(1))];
    end

    return1
    %% Plotting
    figure()
    hold on
    subplot(2,1,1)
    plot(paramValues.(param), return1)
    ylabel('Return Time (min)')
    legend('Li', 'Sturis', 'Tolic')
    subplot(2,1,2)
    plot(paramValues.(param), return2)
    xlabel('Paramter Value')
    ylabel('Return Time (min)')
    %%
end
toc()