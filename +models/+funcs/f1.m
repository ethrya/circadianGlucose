function f=f1(G, const)
% ISR dependence on glucose
% const=models.constants;
if length(const.C)==0
    f=const.Rm./(1+exp((const.C1-G/const.Vg)/const.a1));
else
    C = 1;%1-const.g1*const.C;
    f = const.Rm./(1+exp((C.*const.C1-G./(const.Vg))./(const.a1)));
end
    