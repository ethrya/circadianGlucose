clear all;
const = models.constants;
const.tau1 = 7;
const.tau2 = 36;
const.td = 36;
const.Gin = 0;

paramValues = 1000:100:3000;
return1 = zeros(length(paramValues, 1));

tmin = 3000;

for i=1:paramValues
    const.C1 = paramValues(i);

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

    time = [0, 1500];

    sol = liSolver(liState, const, time);
    [t, y] = sturisSolver(sturisState, const, time);
    [tT, yT] = tolicSolver(sturisState, const, time);


    % Vector of baseline values for Li, sturis, Tolic
    baseLines = [mean(sol.y(1, sol.x>tmin)), mean(y(t>tmin, 3)),...
                mean(yT(tT>tmin, 3))];
    yG = y(:,3);        
    belowBaseIdx = find(yG<baseLines(2));
    return1(i) = t(belowBaseIdx(1));
    
end

plot(parameterValues, return1)
xlabel('Paramter Value')
ylabel('Return Time (min)')
