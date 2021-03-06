clear
load("/import/suphys1/erya7975/simResults/2018-05-30/run_03/i-000_j-000_EET")

runNo = 3;
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
saveas(gcf,strcat('/suphys/erya7975/Dropbox (Sydney Uni Student)/Circadian Glucose Dynamics/Sim_results/2018-05-30/EET_run_',...
    num2str(runNo.','%02d'), 'Gb_bar.png'))
%% mean life
[muStarTau, muTau, sigmaTau] = parameter_sensitivity.EET_means(EEsReturnAmplitude, k);
parameter_sensitivity.plot_EET(paramList, muStarTau, sigmaTau)
saveas(gcf,strcat('/suphys/erya7975/Dropbox (Sydney Uni Student)/Circadian Glucose Dynamics/Sim_results/2018-05-30/EET_run_',...
    num2str(runNo.','%02d'), 'tau_bar.png'))
%% t1 Return time
[muStarT1, muT1, sigmaT1] = parameter_sensitivity.EET_means(EEsReturnTime, k);
parameter_sensitivity.plot_EET(paramList, muStarT1, sigmaT1)
saveas(gcf,strcat('/suphys/erya7975/Dropbox (Sydney Uni Student)/Circadian Glucose Dynamics/Sim_results/2018-05-30/EET_run_',...
    num2str(runNo.','%02d'), 't1_bar.png'))
%% Histograms
figure()
modelColors = [1 0 0; 0 1 0; 0 0 1];
for i=2:k+1
    subplot(4,5,i-1)
    hold on
    for model = 1:3
        h = histogram(tau(:,i,model), -300:20:0);
        h.FaceColor = 'none';
        h.EdgeColor = modelColors(model,:);
        title(paramList(i-1))
        xlabel('\tau (min)')
        xlim([min(min(min(tau))) max(max(max(tau)))])
    end
    hold off
end

%%
figure()
modelColors = [1 0 0; 0 1 0; 0 0 1];
for i=2:k+1
    subplot(4,5,i-1)
    hold on
    for model = 1:3
        h = histogram(Gb(:,i,model), 0:1000:20000);
        h.FaceColor = 'none';
        h.EdgeColor = modelColors(model,:);
        title(paramList(i-1))
        xlabel('G_b (mg)')
        xlim([min(min(min(Gb))) max(max(max(Gb)))])
    end
    hold off
end

%%


%% Overall Histogram G_b
hold on
modelColors = [0 0 1; 0 0 0;  0.5 0 0.5];

for model = 1:3
    h = histogram(Gb(:,:,model), 0:1000:20000);
    h.FaceColor = 'none';
    h.LineWidth = 2;
    h.DisplayStyle = 'stairs';
    h.EdgeColor = modelColors(model,:);
end
xlabel('G_b (mg)')
xlim([min(min(min(Gb))) max(max(max(Gb)))])
line([7000, 7000], ylim, 'LineWidth',2, 'Color', 'g')
line([10000, 10000], ylim, 'LineWidth',2, 'Color', [1 0.5 0])
line([12500, 12500], ylim, 'LineWidth',2, 'Color', 'r')
legend('Li', 'Sturis', 'Tolic', 'Normal', 'High Risk', 'Diabetes')
ylabel('Number of simulations')
hold off



% %%
% %% Convergence plot
% muStar = zeros(k, 3, r);mu = zeros(k, 3, r); sigma = zeros(k, 3, r);
% for i=1:r
%     [muStar(:,:,i), mu(:,:,i), sigma(:,:,i)] = parameter_sensitivity.EET_means(EEsReturnAmplitude(1:i,:,:), k);
% end
% figure()
% for j = 1:3
%     subplot(2,3,j)
%     hold on
%     for i = 1:k
%         plot(1:r, reshape(muStar(i,j,:),[r 1]))
%     end
%     ylabel('\mu^*')
%     title(models(j))
% end
% 
% for j = 1:3
%     subplot(2,3,j+3)
%     hold on
%     for i = 1:k
%         plot(1:r, reshape(sigma(i,j,:),[r 1]))
%     end
%     ylabel('\sigma')
%     xlabel('r')
% end
% saveas(gcf,strcat('/suphys/erya7975/Dropbox (Sydney Uni Student)/Circadian Glucose Dynamics/Sim_results/2018-05-30/EET_run_',...
%     num2str(runNo.','%02d'), 'tau_EET_convergence.png'))
% 
% %%
% %% Convergence plot
% muStar = zeros(k, 3, r);mu = zeros(k, 3, r); sigma = zeros(k, 3, r);
% for i=1:r
%     [muStar(:,:,i), mu(:,:,i), sigma(:,:,i)] = parameter_sensitivity.EET_means(EEsReturnTime(1:i,:,:), k);
% end
% figure()
% for j = 1:3
%     subplot(2,3,j)
%     hold on
%     for i = 1:k
%         plot(1:r, reshape(muStar(i,j,:),[r 1]))
%     end
%     ylabel('\mu^*')
%     title(models(j))
% end
% 
% for j = 1:3
%     subplot(2,3,j+3)
%     hold on
%     for i = 1:k
%         plot(1:r, reshape(sigma(i,j,:),[r 1]))
%     end
%     ylabel('\sigma')
%     xlabel('r')
% end
% saveas(gcf,strcat('/suphys/erya7975/Dropbox (Sydney Uni Student)/Circadian Glucose Dynamics/Sim_results/2018-05-30/EET_run_',...
%     num2str(runNo.','%02d'), 't1_EET_convergence.png'))