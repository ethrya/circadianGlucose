% Simulation of discrete plot in Saad et al 2012
clear;
mealTimes = [7 13 19];
sampleTimes = [0, 5, 10, 20, 30, 60, 90, 120, 150, 180, 270, 360];

G = zeros(3, length(sampleTimes));
I = zeros(3, length(sampleTimes));

const = models.constants;
const.g1 = 0.25;
%const.phi1 = pi;
const.g2 = 0.02;
%const.phi2 = 0;
%const.g3 = 0.3;
%const.phi3 = 0;

%const.C1 = 1720; const.Rm = 150; const.a1 = 350;
%const.C5 = 18.6; const.Rg = 181.5; const.alpha = 0.1168;
%const.Vg = 13.3; const.Vi = 3.15; const.Vp = 5;

for i = 1:length(mealTimes)
    [G(i,:), I(i,:), Gin] = protocols.discreteMealSampler(const,...
        mealTimes(i), sampleTimes);
end

%% Plots
subplot(2,2,2)
hold on
for i = 1:length(mealTimes)
plot(sampleTimes, G(i,:)/1000,'o-')
end
xlabel('Time (min)')
ylabel('[G] (mg/dl)')
legend('Breakfast', 'Lunch', 'Dinner')
title('a) f_3')
xlim([0 360])

subplot(2,2,4)
hold on
for i = 1:length(mealTimes)
plot(sampleTimes, I(i,:),'o-')
end
xlabel('Time (min)')
ylabel('[I_p] (\muU/ml)')
xlim([0 360])

