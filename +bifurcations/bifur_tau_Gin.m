function bifur_tau_Gin(Gin, tau, outPath, nCores)
%% Function to calculate areas where the models display limit cycles.
% Inputs:
% Gin: Vector of glucose infusion values (mg/min) (e.g. 0:5:200)
% tau: Vector of HGP time delays (min) (must be positive e.g. 1:5:100)
% outPath: location to save results (string)
% nCores: Number of cores for computations (default=3)
% Output:
% Saves arrays of binary limit/no-limit outcomes, Gin and Tau values to
% outPath.

tic
% Set default number of cores
if nargin==3
    nCores = 3;
end

% Check output path exists
splitPath = strsplit(outPath, '/');
if 7~=exist(string(join(splitPath(1:end-1), '/')), 'dir')
    error('Output path does not exist')
end

% Lengths of Bifurification parameter arrays
nGin = length(Gin);
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

% Create parallel pool (if one doesn't already exist and multiple cores
% requested)
if nCores>1
    try
        poolobj = parpool(nCores);
    catch
        delete(gcp('nocreate'))
        poolobj = parpool(nCores);
    end
end

%% Find Values
for i=1:nGin
    fprintf('Completing %i of %i Gin Values \n', i, nGin);
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
save(outPath,'LiResults','SturisResults','TolicResults','Gin', 'tau');

end
