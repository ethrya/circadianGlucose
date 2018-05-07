function f  = f4(I, const)
    % (Intersitiaial) Insulin dependent glucose utilisation
    % const = models.constants;
    
    f = const.U0+(const.Um-const.U0)/(1+exp(-const.beta*log(I/const.C4*...
        (1/const.Vi+1/(const.E*const.ti)))));