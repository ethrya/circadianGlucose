function baseHist(baseG, baseI)

baseG = baseG/100;
baseI = baseI/10;
subplot(2,2,1)
hold on
modelColors = [0 0 1; 0 0 0;  0.5 0 0.5];
minG = min(min(min(baseG))); maxG = max(max(max(baseG)));
maxN = 120;
rectangle('Position',[minG, 0, 70-minG, maxN+10], 'FaceColor', [1 0 0 0.25])
rectangle('Position',[70,0,30,maxN+10], 'FaceColor', [0 1 0 0.25])
rectangle('Position',[100,0,25,maxN+10], 'FaceColor', [1 1 0 0.25])
rectangle('Position',[125,0,maxG,maxN+10], 'FaceColor', [1 0 0 0.25])

for model = 1:3
    h = histogram(real(baseG(:,model)), 0:5:200);
    h.FaceColor = 'none';
    h.LineWidth = 2;
    h.DisplayStyle = 'stairs';
    h.EdgeColor = modelColors(model,:);
end
xlabel('[G]_b (mg/dl)')
xlim([min(min(min(baseG))) max(max(max(baseG)))])
% line([70, 70], ylim, 'LineWidth',2, 'Color', 'g')
% line([100, 100], ylim, 'LineWidth',2, 'Color', [1 0.5 0])
% line([125, 125], ylim, 'LineWidth',2, 'Color', 'r')

ylabel('Number of simulations')
hold off

subplot(2,2,2)

hold on
for model = 1:3
    h = histogram(real(baseI(:,model)), 0:.5:200);
    %h = histogram(360*real(baseI(:,model))./(real(baseG(:,model))-63), 0:5:200);
    h.LineWidth = 2;
    h.DisplayStyle = 'stairs';
    h.EdgeColor = modelColors(model,:);
end
ylabel('Number of simulations')
xlim([min(min(min(baseI))) max(max(max(baseI)))])
%xlabel('\beta cell functionality (%)')
xlabel('[I]_B (\mu U/ml)')
LH(1) = plot(nan,nan,'color',modelColors(1,:)); L{1} = 'Li';
LH(2) = plot(nan,nan,'color',modelColors(2,:)); L{2} = 'Sturis';
LH(3) = plot(nan,nan,'color',modelColors(3,:)); L{3} = 'Tolic';
legend(LH, L)%, 'Normal', 'High Risk', 'Diabetes')
hold off

subplot(2,2,3)
hold on
for model = 1:3
    h = histogram(real(baseI(:,model)).*real(baseG(:,model))/402);%, 0:.5:200);
    %h = histogram(360*real(baseI(:,model))./(real(baseG(:,model))-63), 0:5:200);
    h.LineWidth = 2;
    h.DisplayStyle = 'stairs';
    h.EdgeColor = modelColors(model,:);
end
ylabel('Number of simulations')
%xlim([min(min(min(baseI))) max(max(max(baseI)))])
xlabel('HOMA-IR')
%xlabel('[I]_B (\mu U/ml)')
hold off


subplot(2,2,4)

hold on
for model = 1:3
    %h = histogram(real(baseI(:,model)).*real(baseG(:,model))/402);%, 0:.5:200);
    h = histogram(360*real(baseI(:,model))./(real(baseG(:,model))-63), 0:5:200);
    h.LineWidth = 2;
    h.DisplayStyle = 'stairs';
    h.EdgeColor = modelColors(model,:);
end
ylabel('Number of simulations')
%xlim([min(min(min(baseI))) max(max(max(baseI)))])
xlabel('\beta cell functionality (%)')
%xlabel('[I]_B (\mu U/ml)')
hold off
