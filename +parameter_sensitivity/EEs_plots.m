clear
load("../simResults/2018-05-29/run_00/i-000_j-000_EET")

delta = 2*c/p;

%% Calculate EEs
EEs = parameter_sensitivity.calculateEEs(Gb, delta);
EEsReturnAmplitude = parameter_sensitivity.calculateEEs(tau, delta);
EEsReturnTime = parameter_sensitivity.calculateEEs(t1, delta);

%%
paramList = cellstr(['Vp   '; 'Vi   '; 'Vg   '; 'E    '; 'tp   ';...
                     'ti   '; 'td   '; 'Rm   '; 'Rg   '; 'a1   ';...
                     'Ub   '; 'U0   '; 'Um   '; 'beta '; 'alpha';...
                     'C1   '; 'C2   '; 'C3   '; 'C4   '; 'C5   ']);
%paramList = cellstr(['C1   '; 'C2   ']);         
%% [G]_B
[muStarGb, muGb, sigmaGb] = parameter_sensitivity.EET_means(EEs, k);
parameter_sensitivity.plot_EET(paramList, muStarGb, sigmaGb)
%% mean life
[muStarTau, muTau, sigmaTau] = parameter_sensitivity.EET_means(EEsReturnAmplitude, k);
parameter_sensitivity.plot_EET(paramList, muStarTau, sigmaTau)

%% t1 Return time
[muStarT1, muT1, sigmaT1] = parameter_sensitivity.EET_means(EEsReturnTime, k);
parameter_sensitivity.plot_EET(paramList, muStarT1, sigmaT1)