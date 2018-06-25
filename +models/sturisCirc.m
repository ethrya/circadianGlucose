function out = sturisCirc(t, in, const)
    % Model based on Sturis et al. (1991)
    
    % Constant Parameters
    Vp=const.Vp; Vi=const.Vi; E=const.E; 
    tp=const.tp; ti=const.ti; td=const.td;
    
    Gin = const.Gin;
    
    % Insulin and Glucose amounts
    Ip = in(1); Ii = in(2); G = in(3);
    
    % Convert t into circadian frequency
    const.C = 2*pi*t/1440;
    
    %% Model Equations
    out = zeros(6,1);
    out(1) = models.funcs.f1(G,const) -E*(Ip/Vp-Ii/Vi)-Ip/tp;
    out(2) = E*(Ip/Vp-Ii/Vi)-Ii/ti;
    out(3) = Gin-models.funcs.f2(G,const)-models.funcs.f3(G,const)*...
        models.funcs.f4(Ii,const)+models.funcs.f5(in(6), const);%*...
        %models.funcs.f6(G,const)-models.funcs.f7(G,const);
    out(4) = 3/td*(Ip-in(4));
    out(5) = 3/td*(in(4)-in(5));
    out(6) = 3/td*(in(5)-in(6));
end