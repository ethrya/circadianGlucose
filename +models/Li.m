function out = Li(~, currentIn, lag, const)
    %consts = models.constants;
    
    G = currentIn(1); I = currentIn(2);
    gLag = lag(:, 1); iLag = lag(:, 2);
        
    out = zeros(2,1);
    out(1) = const.Gin*(10*const.Vg)-models.funcs.f2(G, const)-...
           models.funcs.f3(G, const)*models.funcs.f4(I, const)+models.funcs.f5(iLag(2), const);
    out(2) = models.funcs.f1(gLag(1), const)-const.di*I;