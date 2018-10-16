%% Code to create a function for Gin(t) following a meal.
% Uses Ra values from Saad et al. (2012)

% Data for Ra from Saad (2012) figure2A breakfast
Saad = [8.665207877461711, 20.178890876565305
19.299781181619267, 69.12343470483006
29.540481400437628, 71.2701252236136
59.8687089715536, 46.22540250447228
88.62144420131291, 23.47048300536673
120.91903719912476, 22.32558139534885
150.4595185995624, 12.593917710196791
181.18161925601754, 9.874776386404307
239.86870897155364, 6.583184257602866
300.13129102844647, 3.148479427549205
360.00000000000006, 3.0053667262969697];

% Convert mumol/kg/min to mg/min
Gin = Saad(:,2)*18*10*70/1000;

% Choose (visually) fitting function
fitFunc = fittype('k*(x-x0)^(n)/b^2*exp(-(x-x0)^n/(b^2))');

% Set boundaries and methods to ensure fitting is realistic
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [80, 5000, 2, 0.95]; 
opts.Lower      = [0 0 0 0]; % allow for a very small range of change for a and b
opts.Upper      = [Inf Inf Inf 20];

% Create best fitting curve
f = fit(Saad(:,1),  Gin, fitFunc, opts);

% Plot final fit
hold on
scatter(Saad(:,1), Gin)
x = f.x0:400;
plot(x, f.k*(x-f.x0).^(f.n)./f.b^2.*exp(-(x-f.x0).^f.n/f.b^2))
xlabel('Time (min)')
ylabel('G_{in} (mg/min)')
hold off

% Calculate total meal (AUC) in mg by integrating area
mealTotalSaad = trapz(Saad(:,1), Gin);
sprintf('Total meal size in Saad et al. 2012 is %.2f g',mealTotalSaad/1000)

mealTotalFunc = trapz(x, f.k*(x-f.x0).^(f.n)./f.b^2.*exp(-(x-f.x0).^f.n/f.b^2));
sprintf('Total meal size of function is %.2f g',mealTotalFunc/1000)
