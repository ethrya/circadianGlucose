function C = skewSine(t,ps,Ac)
%skewed sinusoidal function
%Takes a vector of times (hours) and amplitude&phase shift,
    % or uses defaults
% Author: Svetlana Postnova
wc = 2*pi/(24); % s^(-1)

if nargin==1
    ps = -0.209*pi/wc; % phase shift
    Ac = 1; % amplitude
end

C = Ac * ( + 0.97  * sin(1*wc*(ps+t)) ...
           + 0.22  * sin(2*wc*(ps+t)) ...
           + 0.07  * sin(3*wc*(ps+t)) ...
           + 0.03  * sin(4*wc*(ps+t)) ...
           + 0.001 * sin(5*wc*(ps+t)) ...
           );
end

