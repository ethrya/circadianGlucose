clear all
tic
% Bifurification parameter arrays
Gin = 0:1:300;
nGin = length(Gin);

tau = 1:0.5:100;
nTau = length(tau);

%Constants for all trials
const = models.constants;
const.tau1 = 7;

constArray(1:nGin, 1:nTau) = const;

% Initial conditions
% Li et al
liState = [13000; % Glucose
         30]; % Insulin
% Sturis et al. and Tolic et al conditions
sturisState = [30; % Ip
               0; % Ii
               14000; % G
               0; % x1
               0; % x2
               0]; % x3

% Simulation time               
time = [0, 10000];
tmin = 0.9*time(2);

% Vectors for results
% Form: min G, max G, min I, max I
LiResults = zeros(nGin, nTau, 4);
SturisResults = zeros(nGin, nTau, 4);
TolicResults = zeros(nGin, nTau, 4);

fprintf('Starting Simulations \n');

%% Find Values
parfor i=1:nGin
    fprintf('Completed %i of %i Gin Values \n', i, nGin);
    for j=1:nTau
        % Update Gin value
        constArray(i,j).Gin = Gin(i);
        constArray(i,j).tau2 = tau(j);
        constArray(i,j).td = tau(j);

        % Solve Equations
        sol = liSolver(liState, constArray(i,j), time);
        [t, y] = sturisSolver(sturisState, constArray(i,j), time);
        [tT, yT] = tolicSolver(sturisState, constArray(i,j), time);

        % Store Results
        LiResults(i,j,:) = [min(sol.y(1,sol.x>tmin)), max(sol.y(1,sol.x>tmin))...
                          min(sol.y(2,sol.x>tmin)), max(sol.y(2,sol.x>tmin))];
        SturisResults(i,j,:) = [min(y(t>tmin,3)), max(y(t>tmin,3))...
                          min(y(t>tmin,1)), max(y(t>tmin,1))];
        TolicResults(i,j,:) = [min(yT(tT>tmin,3)), max(yT(tT>tmin,3))...
                             min(yT(tT>tmin,1)), max(yT(tT>tmin,1))];
    end
end
toc

%% Save Output
save('/project/RDS-FSC-circadianGlucose-RW/simResults/bifur_02',...
'LiResults','SturisResults','TolicResults','Gin', 'tau');

%save('/suphys/erya7975/results/bifur02',...

exit
%% Plotting
% hold on
% plot(Gin, LiResults(:,3,1), 'b')
% plot(Gin, LiResults(:,3,2), 'b')
% plot(Gin, SturisResults(:,3,1), 'r')
% plot(Gin, SturisResults(:,3,2), 'r')
% plot(Gin, TolicResults(:,3,1), 'y')
% plot(Gin, TolicResults(:,3,2), 'y')
% hold off
