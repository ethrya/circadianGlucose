function f = f2(G, const)
    %Insulin independant glucose utilisation
    % const = models.constants;
    f = const.Ub*(1-exp(-G/(const.C2*const.Vg)));