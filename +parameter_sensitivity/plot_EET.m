function plot_EET(paramList, muStar, sigma)
figure()
subplot(2,1,1)
bar(categorical(paramList),muStar)
ylabel('\mu^*')
%set(gca, 'YScale', 'log')
legend('Li et al.', 'Sturis et al.', 'Tolic et al.')
subplot(2,1,2)
bar(categorical(paramList),sigma)

xlabel('Parameter')
ylabel('\sigma')
%set(gca, 'YScale', 'log')
toc

end

