% Monte Carlo Estimate of Distribution of Glucose and Insulin Distr. 
clear
tic
%path = "C:/Users/ethan/Documents/Uni/simResults/MC/2018-06-19/test/";
path = "/import/suphys1/erya7975/simResults/2018-06-25/run_01/";
%% Parameters and ICs
paramList = cellstr(['Vp   '; 'Vi   '; 'Vg   '; 'E    '; 'tp   ';...
                    'ti   '; 'td   '; 'Rm   '; 'Rg   '; 'a1   ';...
                    'Ub   '; 'U0   '; 'Um   '; 'beta '; 'alpha';...
                    'C1   '; 'C2   '; 'C3   '; 'C4   '; 'C5   ']);


const = models.constants;

I0 = 40;
G0 = 10000;

nSims = 10000;

randomNumbers = 0.1*(randn(length(paramList), nSims));

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
