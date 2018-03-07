function out = Li(t, currentIn, lag)
    consts = models.constants;
    
    G = currentIn(1); I = currentIn(2);
    gLag = lag(:, 1); iLag = lag(:, 2);
    
    out = zeros(2,1);
    out(1) = consts.Gin*(10*consts.Vg)-models.funcs.f2(G)-...
           models.funcs.f3(G)*models.funcs.f4(I)+models.funcs.f5(iLag(2));
    out(2) = models.funcs.f1(gLag(1))-consts.di*I;