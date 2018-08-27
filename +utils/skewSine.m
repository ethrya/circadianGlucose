function C = skewSine(ps,wc,Ac)
%skewSine function.
% Either takes all 3 arguements, or uses defaults
% Author: Svetlana Postnova
if nargin==0
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

