clear all;
const = models.constants;
const.tau1 = 7;
const.tau2 = 36;
const.td = 36;
const.Gin = 100;


% Initial conditions
liState = [13000; % Glucose
         30]; % Insulin

%% Preliminaries
% Change constants here

% Create initial condition
sturisState = [30; % Ip
               0; % Ii
               14000; % G
               0; % x1
               0; % x2
               0]; % x3

time = [0, 15000];
tmin = 0;

%% Solve ODEs
%sol = liSolver(liState, const, time);
[t, y] = sturisSolver(sturisState, const, time);
%[tT, yT] = tolicSolver(sturisState, const, time);

%t=time(1):0.01:time(2);

%y=sin(0.5*pi*t);

state = [2; 0]; %initial (y', y)

%[t, y] = ode15s(@vdp1000, time, state);
figure()
plot(t(t>tmin),y(t>tmin))
%% FFT preliminaries
% Define sampling frequency and eqully spaced time vector
t = t(t>tmin);
y = y(t>tmin);

Fs = 1;
T = 1/Fs;
L = (time(2)-tmin)*Fs;

tEqual = (0:(L-1))*T;


%% Create equally spaced sample of ODE solution
yEqual = interp1(t, y, tEqual);

yEqual = yEqual(~isnan(yEqual));
tEqual = tEqual(~isnan(yEqual));


%% Do FFT
ydft = fft(yEqual);

% ydft = ydft(1:L/2+1);
% psdy = (1/(Fs*L)) * abs(ydft).^2;

P2 = abs(ydft/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

% psdy(2:end-1) = 2*psdy(2:end-1);
freq = Fs*(0:(L/2))/L;

%freq = (0:nfft/2-1)*Fs/nfft;

figure()
plot(freq, P1)

%% Sine DE Function
   % y''=-y let v:=y' then y=-v'. Define vector u'=(v,y)

function dydt = vdp1000(t,y)
%VDP1000  Evaluate the van der Pol ODEs for mu = 1000.
%
%   See also ODE15S, ODE23S, ODE23T, ODE23TB.

%   Jacek Kierzenka and Lawrence F. Shampine
%   Copyright 1984-2014 The MathWorks, Inc.

dydt = [y(2); 1000*(1-y(1)^2)*y(2)-y(1)];
end
        
    