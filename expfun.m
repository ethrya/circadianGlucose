%objective function for optimization toolbox solver to fit exponential
%function
% Author: Sveta Postnova, 04/06/2018


function expform = expfun(x, a, b, tau)

expform = a + b*exp(-x/tau);

end

