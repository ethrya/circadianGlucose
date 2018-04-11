clear all;
tic()
const = models.constants;
const.tau1 = 7;
const.tau2 = 36;
const.td = 36;
const.Gin = 0;

paramValues = 74:10:214;
return1 = zeros(length(paramValues), 3);
return2= zeros(length(paramValues), 3);
tmin = 3000;

for i=1:length(paramValues)
    const.C2 = paramValues(i);

    % Initial conditions
    liState = [15000; % Glucose
             30]; % Insulin

    %% Preliminaries
    % Create initial condition
    sturisState = [30; % Ip
                   0; % Ii
                   15000; % G
                   0; % x1
                   0; % x2
                   0]; % x3

    time = [0, 5000];

    sol = liSolver(liState, const, time);
    [t, y] = sturisSolver(sturisState, const, time);
    [tT, yT] = tolicSolver(sturisState, const, time);


    % Vector of baseline values for Li, sturis, Tolic
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

%% Plotting
figure()
hold on
subplot(2,1,1)
plot(paramValues, return1)
ylabel('Return Time (min)')
legend('Li', 'Sturis', 'Tolic')
subplot(2,1,2)
plot(paramValues, return2)
xlabel('Paramter Value')
ylabel('Return Time (min)')
%%
toc()