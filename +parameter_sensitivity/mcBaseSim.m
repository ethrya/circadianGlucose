% Monte Carlo Estimate of Distribution of Glucose and Insulin Distr. 
function mcBaseSim(nSims, outPath, nCores)
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

%% Parameters and ICs
paramList = cellstr(['Vp   '; 'Vi   '; 'Vg   '; 'E    '; 'tp   ';...
                    'ti   '; 'td   '; 'Rm   '; 'Rg   '; 'a1   ';...
                    'Ub   '; 'U0   '; 'Um   '; 'beta '; 'alpha';...
                    'C1   '; 'C2   '; 'C3   '; 'C4   '; 'C5   ']);


const = models.constants;

I0 = 40;
G0 = 10000;

randomNumbers = 0.1*(randn(length(paramList), nSims, 'single'));

try
    poolobj = parpool(nCores);
catch
    delete(gcp('nocreate'))
    poolobj = parpool(nCores);
end


%% Simulations
% Loop over parameters and then loop over parameter values.
[baseG, baseI] = parameter_sensitivity.simulateBase(const, paramList,...
                    randomNumbers, path, I0, G0);
%% Save
                save(strcat(path,"baselines"), 'baseG', 'baseI', 'const')
%% Plots
parameter_sensitivity.baseHist(baseG, baseI)
%saveas(gcf,strcat('/suphys/erya7975/Dropbox (Sydney Uni Student)/Circadian Glucose Dynamics/Sim_results/baselineHists/2018-06-25_run_01.fig'))
toc
end
