function C = skewSine(t,ps,wc,Ac)
%skewed sinusoidal function
%Takes a vector of times (hours) and either all 3 parameters,
    % or uses defaults
% Author: Svetlana Postnova
if nargin==1
    ps = 0.2168*pi; % phase shift
    wc = 2*pi/(24); % s^(-1)
    Ac = 1; % amplitude
end

C = Ac * ( + 0.97  * sin(1*wc*(ps+t)) ...
           + 0.22  * sin(2*wc*(ps+t)) ...
           + 0.07  * sin(3*wc*(ps+t)) ...
           + 0.03  * sin(4*wc*(ps+t)) ...
           + 0.001 * sin(5*wc*(ps+t)) ...
           + 1 );
end

