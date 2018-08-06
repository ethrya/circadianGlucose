function out = Li(t, currentIn, lag, const)
%consts = models.constants;

% see if Gin is a constant and either use the constant value or linear
% interpolation of the vector of values.
if length(const.Gin)==1
    Gin = const.Gin;
elseif length(const.Gin)>1
    if max(const.times==t)==1
        Gin = const.Gin(const.times==t);
    else
        Gin = interp1(const.times, const.Gin, t);
    end
end

% Convert t into circadian frequency
const.C = 2*pi*t/1440;

G = currentIn(1); I = currentIn(2);
gLag = lag(:, 1); iLag = lag(:, 2);

out = zeros(2,1);
out(1) = Gin-models.funcs.f2(G, const)-...
    models.funcs.f3(G, const)*models.funcs.f4(I, const)+...
    models.funcs.f5(iLag(2), const);%*models.funcs.f6(G,const)-models.funcs.f7(G,const);
out(2) = models.funcs.f1(gLag(1), const)-const.di*I;

end