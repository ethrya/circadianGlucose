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

% Brandt 2001
brandt = [18.4632, 927.273;
15.685, 735.1398;
10.9868, 475.5897;
7.458, 255.6699;
4.6825, 71.6183];


hold on
% Convert data to mg/dl and muU/l
scatter(jones(:,1)*18, jones(:,2)/6.91, '.')
scatter(byrne(:,1)*18, byrne(:,2)*23/6.91, '.') %Assume BMI=23
scatter(brandt(:,1)*18, brandt(:,2)/6.91, '.')
G = 0:350;
const = models.constants;
plot(G, models.funcs.f1(G*100, const))
plot(G, 150./(1+exp((17.2-G/10)/3.5)))
plot(G, 150./(1+exp((16.9-G/10)/3.8)))
plot(G, 117*G.^4.2./(155^4.2+G.^4.2))
xlabel('[G] (mg/dl)')
ylabel('ISR (\mu U/min)')
legend('Jones', 'Byrne', 'Brandt', 'f_1', 'New f_1', 'Koenig')
hold off