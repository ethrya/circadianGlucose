function yOut = rk4step(model, t0, t1, yIn, const)
h = t1-t0;
k1 = h*model(t0, yIn, const);
k2 = h*model(t0+h/2, yIn+k1/2, const);
k3 = h*model(t0+h/2, yIn+k2/2, const);
k4 = h*model(t1, yIn+k3, const);

yOut = yIn+1/6*(k1+2*k2+2*k3+k4);
end