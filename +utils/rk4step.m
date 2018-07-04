function yOut = rk4step(model, t0, t1, yIn, const)
h = t1-t0;
k1 = h*@(t, y) model(t, y, const);
k2 = h*@(t, y) model(t+h/2, y+k1/2, const);
k3 = h*@(t, y) model(t+h/2, y+k2/2, const);
k4 = h*@(t, y) model(t+h, y+k3, const);

yOut = yIn+1/6*(k1+2*k2+2*k3+k4);
end