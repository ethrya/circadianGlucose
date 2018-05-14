function sC = sinCirc(C, g)
%Variation about some sinusoidal time given the time and a coupling
%strength
sC = 1+g*sin(2*pi/(60*24)*C);
end

