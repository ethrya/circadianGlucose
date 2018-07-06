% Plot of gsIS dose response curve

% Data from Byrne 1996 fig 2 control (col 1-glucose (mMol/dl), col 2-ISR/BMI
% (muUm^2/(min*kg))
byrne = [5.2496, 5.3961;
4.781, 3.7566;
6.6556, 10.2663;
5.8338, 7.9527;
8.5945, 17.935;
7.6058, 14.9462;
9.5221, 24.644];

% Data from Jones 1997 fig 4b sensitive (col 1-[G] (mMol/dl), col 2-ISR(pmol/min)
jones = [4.9973, 116.9733;
5.9967, 187.6834;
6.9874, 266.2953;
7.9777, 351.6774;
8.9846, 442.6949];

hold on
scatter(jones(:,1)*18, jones(:,2)/6)
scatter(byrne(:,1)*18, byrne(:,2)*20/6)
G = 0:300;
const = models.constants;
plot(G, models.funcs.f1(G, const))
xlabel('[G] (mg/dl)')
ylabel('ISR (\mu U/min)')
hold off