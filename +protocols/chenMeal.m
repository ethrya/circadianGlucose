function mealG = chenMeal(t, b, k)
mealG = (k*t)/b^2.*exp(-t.^2/(2*b^2));
end