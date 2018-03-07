function f=f1(G, const)
% ISR dependence on glucose
% const=models.constants;
f=const.Rm/(1+exp((const.C1-G/const.Vg)/const.a1));