% Monte Carlo Estimate of Distribution of Glucose and Insulin Distr. 

clear
path = "C:/Users/ethan/Documents/Uni/simResults/MC/2018-06-19/run_01/";
%% Parameters and ICs
paramList = cellstr(['Vp   '; 'Vi   '; 'Vg   '; 'E    '; 'tp   ';...
                    'ti   '; 'td   '; 'Rm   '; 'Rg   '; 'a1   ';...
                    'Ub   '; 'U0   '; 'Um   '; 'beta '; 'alpha';...
                    'C1   '; 'C2   '; 'C3   '; 'C4   '; 'C5   ']);


const = models.constants;
% Default paramter values
default.Vp = 3; default.Vi = 11; default.Vg = 10; default.E = 0.3; 
default.tp = 6; default.ti = 100; default.td=36; 
default.Rm = 210; default.Rg = 180;
default.a1 = 300; 
default.Ub = 72; default.U0 = 40; default.Um = 940;
default.beta = 1.77; default.alpha = 0.29;
default.C1 = 2000; default.C2 = 144; default.C3 = 1000; default.C4 = 80;
default.C5 = 26;

I0 = 40;
G0 = 10000;

nSims = 10;

randomNumbers = 0.1*(randn(length(paramList), nSims));

%% Simulations
% Loop over parameters and then loop over parameter values.
[baseG, baseI] = parameter_sensitivity.simulateBase(const, paramList,...
                    randomNumbers, path, I0, G0);
                
