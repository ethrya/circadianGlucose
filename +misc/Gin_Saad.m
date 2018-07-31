% Gin values from Saad

% Data for Ra from Saad figure2A breakfast
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

Gin = Saad(:,2)*180*70/1000;

fitFunc = fittype('k*(x-x0)^(n)/b^2*exp(-(x-x0)^n/(b^2))');

opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [80, 5000, 2, 0.95]; 
opts.Lower      = [0 0 0 0]; % allow for a very small range of change for a and b
opts.Upper      = [Inf Inf Inf 20];

f = fit(Saad(:,1),  Gin, fitFunc, opts);

hold on
scatter(Saad(:,1), Gin)
x = f.x0:400;
plot(x, f.k*(x-f.x0).^(f.n)./f.b^2.*exp(-(x-f.x0).^f.n/f.b^2))
xlabel('Time (min)')
ylabel('mg/min')
hold off