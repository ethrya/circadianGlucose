function out = sturis(t, in)
    % Model based on Sturis et al. 1991
    const=models.constants;
    Vp=const.Vp; Vi=const.Vi; E=const.E; 
    tp=const.tp; ti=const.ti; td=const.td;
    
    Gin = const.Gin;
    
    out = zeros(6,1);
    out(1) = models.funcs.f1(in(3)) -E*(in(1)/Vp-in(2)/Vi)-in(1)/tp;
    out(2) = E*(in(1)/Vi-in(2)/Vp)-in(2)/ti;
    out(3) = Gin-models.funcs.f2(in(3))-models.funcs.f3(in(3))*...
        models.funcs.f4(in(2))+models.funcs.f5(in(6));
    out(4) = 3/td*(in(1)-in(4));
    out(5) = 3/td*(in(4)-in(5));
    out(6) = 3/td*(in(5)-in(6));
end