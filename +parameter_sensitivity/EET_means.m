function [muStar, mu, sigma] = EET_means(EEs, k)
% Given a vector of EEs calculate the mean and std  EE for each paramater
% EEs: rows trajectories, columns-paramaters, depth-models
% output variables: rows-parameters, columns- models
muStar = zeros(k,3); mu = zeros(k,3); sigma = zeros(k,3);

for i=1:k
    muStar(i,:) = mean(abs(EEs(:,i,:)),1);
    mu(i,:) = mean(EEs(:,i,:),1);
    sigma(i,:) = std(EEs(:,i,:),1);
end
end