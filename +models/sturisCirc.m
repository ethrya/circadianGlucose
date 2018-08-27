function out = sturisCirc(t, in, const)
% Model based on Sturis et al. (1991) with circadian effects.
% t - time of calculation
% in - vector of input state [Ip ,Ii, G, x1, x2, x3] at t
% const - constants object

% Constant Parameters
Vp=const.Vp; Vi=const.Vi; E=const.E;
tp=const.tp; ti=const.ti; td=const.td;

% see if Gin is a constant and either use the constant value or linear
% interpolation of the vector of values.
if length(const.Gin)==1
    Gin = const.Gin;
elseif length(const.Gin)>1
    if sum(const.times==t)>1
        Gin = const.Gin(const.times==t);
    else
        Gin = interp1(const.times, const.Gin, t);
    end
end


% Insulin and Glucose amounts
Ip = in(1); Ii = in(2); G = in(3);

% Convert t into circadian frequency
const.C = utils.skewSine(t/60);

%% Model Equations
out = zeros(6,1);
out(1) = models.funcs.f1(G,const) -E*(Ip/Vp-Ii/Vi)-Ip/(tp);
out(2) = E*(Ip/Vp-Ii/Vi)-Ii/ti;

% Either calculate the value or use a glucose clamp
if isnan(const.clamp)==1
    out(3) = Gin-models.funcs.f2(G,const)-models.funcs.f3(G,const)*...
        models.funcs.f4(Ii,const)+models.funcs.f5(in(6), const);
else
    out(3) = 0;
end

out(4) = 3/td*(Ip-in(4));
out(5) = 3/td*(in(4)-in(5));
out(6) = 3/td*(in(5)-in(6));
end