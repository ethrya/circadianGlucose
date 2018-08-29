function C = skewSine(t,ps,Ac)
%skewed sinusoidal function
%Takes a vector of times (hours) and amplitude&phase shift,
    % or uses defaults
% Author: Svetlana Postnova
if nargin==1
    ps = -pi/5; % phase shift
    Ac = 1; % amplitude
end

wc = 2*pi/(24); % s^(-1)


C = Ac * ( + 0.97  * sin(1*wc*(ps+t)) ...
           + 0.22  * sin(2*wc*(ps+t)) ...
           + 0.07  * sin(3*wc*(ps+t)) ...
           + 0.03  * sin(4*wc*(ps+t)) ...
           + 0.001 * sin(5*wc*(ps+t)) ...
           );
end

