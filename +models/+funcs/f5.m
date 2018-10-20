function f = f5(x3, const, modelName)
% Hepatic glucose production
% const = models.constants;
if ~exist('modelName','var')
    modelName = 'Other';
end

% Get different parameter for tolic and sturis/li models
if modelName == 'Tolic'
    alpha = const.alphaT;
    C5 = const.C5T;
else
    alpha = const.alpha;
    C5 = const.C5;
end

if length(const.C)==0
    f = const.Rg./(1+exp(alpha*(x3/const.Vp-C5)));
else
    C = 1;
    f = C*const.Rg./(1+exp(alpha*(x3/const.Vp-C5)));
end
end
