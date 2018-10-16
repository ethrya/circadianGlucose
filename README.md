# circadianGlucose
Code from my honours project on physically based modelling of the circadian influence on glucose-insulin homeostasis.
The project contains two main components. The first is a numerical analysis of the Sturis et al. (1991), Tolic et al. (2000), and Li et al. (2006) models. The second is the development of a model which incorporates circadian effects.

# Prerequisites
1. MATLAB2017b. Scripts which I know don't work on earlier versions are labeled, although there may be others.
2. Statistics toobox
3. Parallel computing toolbox

# Usage
## Basic usage
- Model Simulations. The easiest usage is to run sims.compare_sturis_li which plots dynamics and phase planes for all three models. Parameters, ICs, etc. can be changed in this file.  
- Model Parameters. Default values are set in the models.constants class. It is preferable to call this class and change values in each script only.

## Model Analysis
The Model analysis is contained in folders for each key component.
* Bifurcation analysis. Contained in +bifurcations.
  - Bifuctation plots for one variable can be completed by running bifucations.bifurification_Gin.m and chaning the bifurcation parameter.
  - 2D plot of limit cycle locations. Initial data created and saved using bifurcations.bifur_tau_Gin.m. Plot created using (TBC).
* MC simulation. Simulation and plot can be created by running parameter_sensitivity.mcBaseSim.m with the appropriate input.
* Parameter Sensitivity.
  - Local Sensitivity analysis. Can be performed by running parameter_sensitivity.local_sensitivity.
  - EET. Performed by running 

## Circadian Models
- Each model has its only solver for the circadian component. These work similarly to compare_sturis_li.m except solve the circadian and non-circadian models.
- Circadian variations to the models can be added by varying the models functions in +funcs or the original models.
 
## Unit tests
The unit test coverage is admitedly not ideal (TODO!), however some key functions have unit tests in the tests file.

# Authors
- Ethan Ryan
- Svetlana Postnova
- Zdenka Kuncic
