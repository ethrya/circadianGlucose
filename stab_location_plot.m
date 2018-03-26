% Code to create plot of locations where models are stable/limit cycles

% Load data
data = load('../simResults/bifur06');

liStab = abs(data.LiResults(:,:,1)-data.LiResults(:,:,2))<1;
sturisStab = abs(data.SturisResults(:,:,1)-data.SturisResults(:,:,2))<1;
tolicStab = abs(data.TolicResults(:,:,1)-data.TolicResults(:,:,2))<1;

[Tau,Gin]=meshgrid(data.tau, data.Gin);

figure
mesh(Tau,Gin,liStab);
figure
mesh(Tau, Gin, sturisStab);
figure
mesh(Tau, Gin, tolicStab);
%set(gca, 'XTick', 1:5, 'XTickLabel', data.tau);