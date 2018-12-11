# circadianGlucose
Code from my honours project on physically based modelling of the circadian influence on glucose-insulin homeostasis.
The project contains two main components. The first is a numerical analysis of the Sturis et al. (1991), Tolic et al. (2000), and Li et al. (2006) models. The second is the development of a model which incorporates circadian effects.

Included here is also additional code used throughout the project generally to test various ideas and simulate other studies. Space requirements meant much of this was not included in my final thesis.

# Prerequisites
1. MATLAB2017b
2. Statistics toobox
3. Parallel computing toolbox
4. Curve Fitting Toolbox
5. Symbolic Math Toolbox

I have tried to comment on the specific functions and scripts which I know require one of these prerequisites, although there are likely other dependencies.

# Usage
## Basic usage
- Original Model Simulations. The easiest usage is to run sims.compare_sturis_li which plots dynamics and phase planes for all three models. Parameters, ICs, etc. can be changed in this file.
  * Note sturisSolver and liSolver both use ODE45 with a variable timestep. ODESolver used a 4th order fixed timestep runge-Kutta.
- Model Parameters. Default values are set in the models.constants class. It is preferable to call this class and change values in the script where the simulations are being called only.
- Circadian Model Simulations. Simulations of the Sturis circadian model can be run through sims.circSolver.
  * Other models (e.g. Tolic and Li) can be run through sims.circSolverTolic and sims.circSolverLi, respectively.
  * The circadian clock is implemented by adding a circadian oscillator to the model (models.sturisCirc) or by changing C in the relevant functions files (models.funcs.fi). The example in this repo is for f4.
  * For one one circadian clock, the amplitude is const.g1. 

## Model Analysis
The Model analysis is contained in folders for each key component.
* Bifurcation analysis. Functions contained in +bifurcations.
  - Bifuctation plots for one variable can be completed by running bifucations.bifurification_Gin.m and chaning the bifurcation parameter.
  - 2D plot of limit cycle locations. Initial data created and saved using bifurcations.bifur_tau_Gin. Plot created using bifurcations.stab_overlap.
* MC simulation. Functions contained in +parameter_sensitivity
  - Simulation and plot can be created by running parameter_sensitivity.mcBaseSim.m with the appropriate input.
  - Bootstrap resamples calculated using ourput of the simulation and bifurcations.bootstrapEsts
* Parameter Sensitivity. Functions contained in +parameter_sensitivity
  - Local Sensitivity analysis. Can be performed by running parameter_sensitivity.local_sensitivity.
  - EET. Performed by running 

## Circadian Models
- Each model has its only solver for the circadian component. These work similarly to compare_sturis_li.m except solve the circadian and non-circadian models.
- Circadian variations to the models can be added by varying the models functions in +funcs or the original models.
 
## Unit tests
The unit test coverage is admitedly not ideal (dynamics tests have generally been used instead), however some key functions have unit tests in the tests file.

The model functions tests can be run by calling

`import matlab.unittest.TestSuite`
`suiteClass = TestSuite.fromClass(?funcTests);`
`result = run(suiteClass);`

For the utility function tests replace funcTests with utilsTests.

# Authors
- Ethan Ryan
- Svetlana Postnova
- Zdenka Kuncic
