function f = f2(G, const)
    %Insulin independant glucose utilisation
    % const = models.constants;
    if length(const.C)==0
        f = const.Ub*(1-exp(-G/(const.C2*const.Vg)));
    else
        C = 1;
        f = const.Ub*(1-exp(-G/(const.C2*const.Vg)));
    end
end