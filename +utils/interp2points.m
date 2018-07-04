function yInterp = interp2points(x, y, xInterp)
%% Linear interpolation between two points
% Given 2 x value and corresp y values, find
% yInt corresp to xInt by interpolation
yInterp = (xInterp-x(1))/(x(2)-x(1))*(y(2)-y(1))+y(1);
end