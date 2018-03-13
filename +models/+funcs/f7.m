function f = f7(G, const)
Sb = const.Sb; Sm = const.Sm; delta = const.delta; Vg = const.Vg;
C3 = const.C3; C7 = const.C7;
f = Sb+(Sm-Sb)/(1+exp(delta*(G/(C3*Vg)-C7)));
end