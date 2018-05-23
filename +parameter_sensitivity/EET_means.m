function [muStar, mu, sigma] = EET_means(EEs, k)
muStar = zeros(k,3); mu = zeros(k,3); sigma = zeros(k,3);

for i=1:k
    muStar(i,:) = mean(abs(EEs(i,:,:)),2);
    mu(i,:) = mean(EEs(i,:,:),2);
    sigma(i,:) = std(EEs(i, :,:),0,2);
end
end