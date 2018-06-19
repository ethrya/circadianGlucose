% fits an exponential to model response to initial condition with high glucose  
% arguments:
%     p - value of peaks of glucose ampount
%     lt - time of the peaks p
%     t - time vector for glucose amount variable in min
%     G - glucose amount in mg
% Author: Sveta Postnova, 04/06/2018

function [fitresult,gof,coeffs, fitfun] = exponentialfit(p,lt,t,G)

x = lt; 
y = p;

% parameters used for fitted_function = a+b*exp(-t/tau):
%               a - baseline glucose level (can be approximated with p(end))
%               b - exponential multiplier (can be approximated with p(1)-p(end))
%               tau - time constant of fitted exponential function

ft = fittype( 'expfun(x,a,b,tau)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [p(end), p(1)-p(end), 30]; 
opts.Lower      = [0.99*p(end)  0.99*(p(1)-p(end)) 0.00001]; % allow for a very small range of change for a and b
opts.Upper      = [1.01*p(end) 1.01*(p(1)-p(end)) 1000];  % allow for a very small range of change for a and b


% function to data
[fitresult, gof] = fit(x,y,ft, opts ); %output of fit and goodness of fit statistics (in gof structure)

% outputs
coeffs = coeffvalues(fitresult);
fitfun = feval(fitresult,t); %creates vector of corresponding G values from fit
