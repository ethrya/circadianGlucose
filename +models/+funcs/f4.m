function f = f4(I, const)
    % (Intersitiaial) Insulin dependent glucose utilisation
    if length(const.C)==0
        f = const.U0+(const.Um-const.U0)/(1+exp(-const.beta*log(I/const.C4*...
            (1/const.Vi+1/(const.E*const.ti)))));
    else
        C = (1+const.g2*sin(const.C+const.phi2));
        f = const.U0+(const.Um-const.U0)/(1+exp(-const.beta*log(C*I/const.C4*...
            (1/const.Vi+1/(const.E*const.ti)))));
    end
end