function sigOut  = sigmoid(x, maxVal, slope, shift)
    sigOut = maxVal./(1+exp(x./slope+shift));
end
