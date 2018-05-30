clear
load("../simResults/2018-05-30/run_01/i-000_j-000_EET")

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

%% Histograms
model = 1;
for i=2:k+1
    subplot(4,5,i-1)
    hist(EEs(:,i,model))
    title(paramList(i-1))
end

%% Convergence plot
muStar = zeros(k, 3, r);mu = zeros(k, 3, r); sigma = zeros(k, 3, r);
for i=1:r
    [muStar(:,:,i), mu(:,:,i), sigma(:,:,i)] = parameter_sensitivity.EET_means(EEs(1:i,:,:), k);
end
figure()
hold on
for j = 1:3
    subplot(2,3,2*j-1)
    for i = 1:k
        plot(1:r, muStar(i,j,:))
    end
    subplot(2,3,2*j)
    for i = 1:k
        plot(1:r, sigma(i,j,:))
    end
end