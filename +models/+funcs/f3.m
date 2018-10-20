function f = f3(G, const)
    %Insulin dependent glucose utilisation depenendance on glucose
    % const = models.constants;
    if length(const.C)==0
        f = G/(const.C3*const.Vg);
    else
        C = 1;
        f = G/(const.C3*const.Vg);
    end
end