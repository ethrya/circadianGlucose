function [freq, P1] = ft_solution(t,y,tmin)
    % Function to calculate the FT of sturis/tolic results, by linearly
    % interpolating results.
    % INPUTS:
    % t - vector of times corresponding to y
    % y - array of solutions at times t
    % tmin - minimum time to begin FT
    % OUTPUTS:
    % freq - vector of frequencies in units 1/[t]
    % P1 - power of frequencies given by freq
    %% FFT preliminaries
    % Define sampling frequency and eqully spaced time vector
    t = t(t>tmin);
    y = y(t>tmin,:);

    time = [0 t(end)];
    
    Fs = 1;
    T = 1/Fs;
    L = (time(2)-tmin)*Fs;

    tEqual = (0:(L-1))*T+tmin;


    %% Create equally spaced sample of ODE solution
    yEqual = interp1(t, y(:,3), tEqual);

    yEqual = yEqual(~isnan(yEqual));
    tEqual = tEqual(~isnan(yEqual));


    %% Do FFT
    yEqual = yEqual - mean(yEqual);
    ydft = fft(yEqual);

    % ydft = ydft(1:L/2+1);
    % psdy = (1/(Fs*L)) * abs(ydft).^2;

    P2 = abs(ydft/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    % psdy(2:end-1) = 2*psdy(2:end-1);
    freq = Fs*(0:(L/2))/L;
end