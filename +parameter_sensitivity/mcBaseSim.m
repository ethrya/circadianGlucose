function mcBaseSim(nSims, outPath, nCores)
% Monte Carlo Estimate of Distribution of Glucose and Insulin Distr. 
% Inputs:
%    nSims: number of MC simulations
%    outPath: location of directory to save sims and baseline values
%    nCores (default = 3)
tic
% Set default number of cores
if nargin==2
    nCores = 3;
end

% Check output path exists
if 7~=exist(outPath, 'dir')
    error('Output path does not exist')
end

%% Parameters and ICs
paramList = cellstr(['Vp   '; 'Vi   '; 'Vg   '; 'E    '; 'tp   ';...
                    'ti   '; 'td   '; 'Rm   '; 'Rg   '; 'a1   ';...
                    'Ub   '; 'U0   '; 'Um   '; 'beta '; 'alpha';...
                    'C1   '; 'C2   '; 'C3   '; 'C4   '; 'C5   ']);


const = models.constants;
const.Gin = 0;

I0 = 40;
G0 = 10000;

randomNumbers = 0.1*(randn(length(paramList), nSims));

if nCores>1
try
    poolobj = parpool(nCores);
catch
    delete(gcp('nocreate'))
    poolobj = parpool(nCores);
end
end


%% Simulations
% Loop over parameters and then loop over parameter values.
disp('Starting Simulations')
[baseG, baseI] = parameter_sensitivity.simulateBase(const, paramList,...
                    randomNumbers, outPath, I0, G0, nSims);
%% Save
                save(strcat(outPath,"baselines"), 'baseG', 'baseI', 'const')
%% Plots
parameter_sensitivity.baseHist(baseG, baseI)
%saveas(gcf,strcat('/suphys/erya7975/Dropbox (Sydney Uni Student)/Circadian Glucose Dynamics/Sim_results/baselineHists/2018-06-25_run_01.fig'))
%%
toc
end
