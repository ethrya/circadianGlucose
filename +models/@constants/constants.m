classdef constants
    %List of constsnats as outlined in Sturis et al. (1991),  
           % Tolic et al (2000), and Li et al. (2006)
    properties
        % Degradation times (min)
        ti = 100;
        tp = 6;
        tpT = 4; %tp from Tolic
        td = 36;
        tdLi = 36; % The degradation time used in Li et al (2006)
        
        % Volume of spaces (l)
        Vi = 11;
        Vp = 3;
        Vg = 10;
        
        % Function parameters
        C1 = 2000; %mg/l
        C2 = 144; %mg/ l
        C3 = 1000; %mg/l
        C4 = 80; %mU/l
        C5 = 26; %mU/l
        C5T = 29;
        C7 = 2.0;
        C6 = 2.0;
        
        
        U0=40; % mg/min
        Um=940; %mg/min
        Ub = 72; %mg/min

        
        % Rate constant of insulin diffusion (l/min)
        E = 0.2; 
        
        Rm = 210; %mU/min
        Rg = 180; %mg/min
        alpha = 0.29; %1/mU
        alphaT = 0.41;
        beta=1.77;
        a1 = 300; % mg/l

        % Li Delays (min)
        tau1 = 7; 
        tau2 = 36;
        
        % Insulin Degradation rate (1/min)
        di = 0.06;
        
        %tolic values
        Sb = 20;
        Sm = 140;
        delta = -2.4;
        gamma = 5.0;
        
        C %Circadian phase
        phi0 = 0; % Initial phase (in rad)
        g = 0.01; %Coupling strength
    end
    
    properties
        % Exogeneous glucose infusion (mg/min)
        Gin = 108;
        % Times corrsponding to Gin values
        times
    end
end

    
  