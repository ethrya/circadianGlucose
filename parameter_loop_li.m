clear all;
tic()
const = models.constants;
const.tau1 = 7;
const.tau2 = 36;
const.td = 36;
const.Gin = 0;

paramValues = 12:6:50;
return1 = zeros(length(paramValues), 3);

tmin = 3000;

for i=1:length(paramValues)
    const.C5 = paramValues(i);

    % Initial conditions
    liState = [15000; % Glucose
             30]; % Insulin

    %% Preliminaries
    % Change constants here

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

    belowBaseIdxLi = find(sol.y(1,:)<baseLines(1));
    belowBaseIdxSturis = find(y(:,3)<baseLines(2));
    belowBaseIdxTolic = find(yT(:,3)<baseLines(3));

    return1(i, :) = [sol.x(belowBaseIdxLi(1)), t(belowBaseIdxSturis(1))...
                     yT(belowBaseIdxTolic(1))];   
end

plot(paramValues, return1)
xlabel('Paramter Value')
ylabel('Return Time (min)')
legend('Li', 'Sturis', 'Tolic')

toc()