function mealG = saadMeal(x)
% Function to create meal using data from Saad 2012 Figure 2A (breakfast)
k = 2448; b = 2.099; n = 0.5849; x0 = 8.346;
mealG = k*(x-x0).^n/b^2.*exp(-(x-x0).^n/(b^2)).*heaviside(x-x0);
end