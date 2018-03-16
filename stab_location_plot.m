% Code to create plot of locations where models are stable/limit cycles

% Load data
data = load('~/results/bifur03');

liStab = abs(data.LiResults(:,:,1)-data.LiResults(:,:,2))<1;
sturisStab = data.SturisResults(:,1,1)-data.SturisResults(:,2,1)<1e-4;
tolicStab = data.TolicResults(:,1,1)-data.TolicResults(:,2,1)<1e-4;

[Tau,Gin]=meshgrid(data.tau, data.Gin);

figure
mesh(Tau,Gin,liStab);
%set(gca, 'XTick', 1:5, 'XTickLabel', data.tau);