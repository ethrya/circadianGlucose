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
default.C5 = 26; default.C5T = 29; default.alphaT = 0.41;

% Define parameter space
k = length(paramList); % Number of parameters
p = 4; % Number of levels
r = 100; % Number of trajectories
c = 0.2; % fraction of default value to sample (e.g. c=0.2 => [0.8,1.2])
delta = 2*c/p; % spacing of trajectories

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
% Loop over trajectories then parameters and then loop over parameter values.
for i=1:r
    % Import constants
    const = models.constants;
    % Change constants from default values
    const.tau1 = 7;
    const.tau2 = 36;
    const.td = 36;
    const.Gin = 0;
    
    % Compute initial parameter values
    % Choose discrete values on U[-c,c-2c/p]
    noise = (2*c-2*c/p)*rand(k,1)-c;
    % Update initial parameter values
    for j=1:length(paramList)
        % Name of parameter
        param = char(paramList(j));
        % Loop over interesting parameter values
        
        % Select value of changing parameter
        const.(param) = default.(param)*(1+noise(j));
        if string(param)=="alpha" || string(param)=="C5"
            const.(strcat(param,'T')) = default.(strcat(param,'T'))*(1+...
                                        noise(j));
        end
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
        const.(param) = const.(param)*(1 + delta);
        if string(param)=="alpha" || string(param)=="C5"
            const.(strcat(param,'T')) = default.(strcat(param,'T'))*(1+delta);
        end
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


%% Bootstrap
model = 3;
muStarCI = zeros(k,3,2); muCI = zeros(k,3,2); sigmaCI = zeros(k,3,2);

for j=1:model
    for i=1:k
        muStarCI(i,j,:) = bootci(1000,@(x) mean(abs(x)), EEs(i,:,j));
        muCI(i,j,:) = bootci(1000,@(x) mean(x), EEs(i,:,j));
        sigmaCI(i,j,:) = bootci(1000,@(x) mean(x), EEs(i,:,j));
    end
end
%%
figure()
subplot(2,1,1)
bar(categorical(paramList),muStar)
ylabel('\mu^*')
%set(gca, 'YScale', 'log')
legend('Li et al.', 'Sturis et al.', 'Tolic et al.')
subplot(2,1,2)
bar(categorical(paramList),sigma)

xlabel('Parameter')
ylabel('\sigma')
%set(gca, 'YScale', 'log')


%%
model = 1;
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
        errorbar(muPlot(i), sigmaPlot(i), sigmaPlot(i,j)-sigmaCI(i,j,1),...
            sigmaCI(i,j,2)-sigmaPlot(i,j), muPlot(i,j)-muStarCI(i,j,1),...
            muStarCI(i,j,2)-muPlot(i,j))
    end
    ylabel('\sigma^*')
    legend(paramList)
end
xlabel('\mu^*')
