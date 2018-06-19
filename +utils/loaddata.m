%% Loads data from files in a given folder and fits an exponential function 
% to glucose data in them. 
% Author: Sveta Postnova, 04/06/2018

clear all
close all

% read in files information from a given folder
allfiles = dir('simulations/*.mat');

% models being tested
model = {'Sturis','Tolic','Li'};

for j = 1:length(model)
    for i = 22:23
        % create filenames to read
        filename{i} = sprintf('simulations/%s',allfiles(i).name);
        % load a file
        load(filename{i});
        
        % compile data
        switch model{j}
            case 'Sturis'
                s(i).G = ySt(:,3);
                s(i).t = tSt;
            case 'Tolic'
                s(i).G = yT(:,3);
                s(i).t = tT;
            case 'Li'
                s(i).G = solLi.y(1,:)';
                s(i).t = solLi.x';
        end
        
        % find peaks
        [p,l] = findpeaks(s(i).G);
        s(i).p = [s(i).G(1); p]; % findpeaks doesn't always recognize the initial value, so we add it manually
        lt = s(i).t(l); % times for peaks locations
        s(i).lt = [0; lt]; % findpeaks doesn't always recognize the initial value, so we add it manually
        
        % fit exponential function to peak times
        [fitresult,gof,coeffs, fitfun] = utils.exponentialfit(s(i).p,s(i).lt,s(i).t, s(i).G);
        s(i).tau = coeffs(3); % time constant
        s(i).fitfun = fitfun; % exponential decay function
        
        % plot results for visual testing
        figure
        plot(s(i).t, s(i).G,'r', lt, p, 'k*', s(i).t,fitfun, 'b')
        title(sprintf('%s, tau = %g', model{j}, coeffs(3)))
        ylabel('G [mg]')
        xlabel('t [min]')
        
        % clear variables
        clear p l fitresult gof coeffs fitfun lt ySt tSt yT tT solLi

    end
    % plot results for visual testing
    figure
    plot([s.tau],'*')
    xlabel('index')
    ylabel('tau [min]')
    title(sprintf('time constants for %s', model{j}))
    
    % save data to file for a specific model
    fname = sprintf('%s_expfits.mat',model{j});
    save(fname, 's');
    
    % clear data structure
    clear s
    
end
