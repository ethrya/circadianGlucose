function plot_EET(paramList, muStar, sigma)
figure()
% Reorder cells f1, f2, f3, f4, f5, general
order = [16 8 10 11 17 18 12 13 19 14 9 15 20 1:4];
muStarSorted = muStar(order,:);
sigmaSorted = sigma(order,:);
paramListSorted = paramList(order);
%paramListSorted(10) = '\beta'; paramListSorted(12) = '\alpha';

subplot(2,1,1)
bar(muStarSorted)
xticklabels(paramListSorted)
xticks(1:length(paramListSorted))
ylabel('\mu^*')
%set(gca, 'YScale', 'log')
legend('Li et al.', 'Sturis et al.', 'Tolic et al.')
subplot(2,1,2)
bar(sigmaSorted)
xticklabels(paramListSorted)
xticks(1:length(paramListSorted))
xlabel('Parameter')
ylabel('\sigma')
%set(gca, 'YScale', 'log')
end
