function f = f5(x3, const)
    % Hepatic glucose production
    const = models.constants;
    
    f = const.Rg/(1+exp(const.alpha*(x3/const.Vp-const.C5)));
   