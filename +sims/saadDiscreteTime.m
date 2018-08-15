% Simulation of discrete plot in Saad et al 2012

mealTimes = [7 14 20];
sampleTimes = [0, 5, 10, 20, 30, 60, 90, 120, 150, 180, 270, 360];

G = zeros(3, length(sampleTimes));
I = zeros(3, length(sampleTimes));

const = models.constants;
const.g1 = 0.05;
const.phi1 = pi;
const.g2 = 0.1;
const.phi2 = 0;
const.g3 = 0.3;
const.phi3 = 0;

for i = 1:length(mealTimes)
    [G(i,:), I(i,:), Gin] = protocols.discreteMealSampler(const,...
        mealTimes(i), sampleTimes);
end

%% Plots
figure()
hold on
for i = 1:length(mealTimes)
plot(sampleTimes, G(i,:))
end

legend('Breakfast', 'Lunch', 'Dinner')
