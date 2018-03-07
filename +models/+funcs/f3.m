function f = f3(G)
    %Insulin dependent glucose utilisation depenendance on glucose
    const = models.constants;
    f = G/(const.C3*const.Vg);