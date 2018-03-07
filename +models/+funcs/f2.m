function f = f2(G)
    %Insulin independant glucose utilisation
    const = models.constants;
    f = const.Ub*(1-exp(-G/(const.C2*const.Vg)));