function f = f5(x3, const, modelName)
% Hepatic glucose production
% const = models.constants;
if ~exist('modelName','var')
    modelName = 'Other';
end

if modelName == 'Tolic'
    alpha = const.alphaT;
    C5 = const.C5T;
else
    alpha = const.alpha;
    C5 = const.C5;
end

f = const.Rg/(1+exp(const.alpha*(x3/const.Vp-const.C5)));
