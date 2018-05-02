%% Note code requires MATLAB 2017a or higher
clear all;

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

% Define parameter space
k = length(paramList); % Number of parameters
p = 4; % Number of levels
r = 10; % Number of trajectories
delta = 1/(p-1); % spacing of trajectories

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

EEs = zeros(k, r, 3);

%% Simulations
% Loop over parameters and then loop over parameter values.
for i=1:r
    % Import constants
    const = models.constants;
    % Change constants from default values
    const.tau1 = 7;
    const.tau2 = 36;
    const.td = 36;
    const.Gin = 0;
    
    % Compute initial parameter values
    % Choose discrete values on U[0,1]
    noise = (unidrnd(r, k, 1)-1)/r;
    % Update parameter values
    for j=1:length(paramList)
        % Name of parameter
        param = char(paramList(j));
        % Loop over interesting parameter values

        % Select value of changing parameter
        const.(param) = default.(param)+noise(j)-0.5;
    end
    
    % Solve equations
    solLi = liSolver(liState, const, time);
    [tSt, ySt] = sturisSolver(sturisState, const, time);
    [tT, yT] = tolicSolver(sturisState, const, time);

    % Vector of baseline values for Li, Sturis, Tolic
    baseLineOld = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                mean(yT(tT>tmin, 3))];
            
    for j=1:k
        % Name of parameter
        param = char(paramList(j));
        % Loop over interesting parameter values

        % Select value of changing parameter
        const.(param) = const.(param) + delta;
        % Solve equations
        solLi = liSolver(liState, const, time);
        [tSt, ySt] = sturisSolver(sturisState, const, time);
        [tT, yT] = tolicSolver(sturisState, const, time);
        
        baseLine = [mean(solLi.y(1, solLi.x>tmin)), mean(ySt(tSt>tmin, 3)),...
                    mean(yT(tT>tmin, 3))];
        
        EEs(j,i,:) = (baseLine-baseLineOld)./delta;
                
        baseLineOld=baseLine;
    end
end

%%
model = 3;
muStar = zeros(k,3); mu = zeros(k,3); sigma = zeros(k,3);

for i=1:k
    muStar(i,:) = mean(abs(EEs(i,:,:)));
    mu(i,:) = mean(EEs(i,:,:));
    sigma(i,:) = std(EEs(i, :,:));
end

%%
figure()
subplot(2,1,1)
bar(categorical(paramList),muStar)
ylabel('\mu^*')
set(gca, 'YScale', 'log')
legend('Li et al.', 'Sturis et al.', 'Tolic et al.')
subplot(2,1,2)
bar(categorical(paramList),sigma)

xlabel('Parameter')
ylabel('\sigma')
set(gca, 'YScale', 'log')


%%
model = 3;
figure()
for j=1:model
subplot(3,1,j)
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
muPlot = muStar(:,j);%(muStar(:,model)>10^(-10) & sigma(:,model)>10^(-10));
sigmaPlot = sigma(:,j);%(muStar(:,model)>10^(-10) & sigma(:,model)>10^(-10));

cmap = jet(2); % Make 1000 colors.

hold on
for i=1:k
scatter(muPlot(i), sigmaPlot(i), 100, '.')
end
ylabel('\sigma^*')
legend(paramList)
end
xlabel('\mu^*')
