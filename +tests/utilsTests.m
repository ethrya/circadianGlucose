% Test class definition
% Tests for various functions
classdef utilsTests < matlab.unittest.TestCase
    methods (Test)
        function testBaselineCritical(testCase)
            %Test baseline for critically damped case
            % Find first time e^(-x)+1 is within 0.1% of 1.
            % Need t_min s.t. 0.999<e^(-t)+1<1.001
            % => t_min = 6.908
            t = 0:0.001:100;
            G = exp(-t)+1;
            funcRes = utils.baseline_return(t, G, 50);
            actSolution = 6.908;
            verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
        end
        
        function testBaselineDamped(testCase)
            % Test baseline for (uncrticially) damped case
            % Find first time e^(-0.1t)cos(0.5t) is within 1% of 0.
            % Need t_min s.t. |e^(-0.1t)cos(0.5t)|<0.01
            % => t_min = \pi
            t = 0:0.01:100;
            G = exp(-0.1*t).*cos(0.5*t);
            funcRes = utils.baseline_return(t, G, 50);
            actSolution = pi;
            verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
        end
        
        function testBaselineLimit(testCase)
            % Test baseline for limit cycle
            % Find first time (e^(-0.1t)+1)cos(0.5t) is within 1% of 1.
            % t_min =\pi/2
            t = 0:0.01:100;
            G = (exp(-0.1*t)+1).*cos(t);
            funcRes = utils.baseline_return(t, G, 50);
            actSolution = pi/2;
            verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
        end
        
        function testAmplitudeBaselineCritical(testCase)
            % Test baseline for critically damped case
            % Find first time e^(-x)+1 is within 1% of 1.
            % Need t_min s.t. 0.99<e^(-t)+1<1.001
            % => t_min = 4.605
            t = 0:0.01:200;
            G = exp(-t)+1;
            funcRes = utils.baselineAmplitude(t, G, 100);
            actSolution = 6.9078;
            verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.001)
        end
        
        function testAmplitudeBaselineLimit(testCase)
            % Test baseline for limit cycle
            % Find first time peak of (e^(-0.1t)+1)cos(0.5t) is within 0.1% of 1.
            % t_min =16*pi
            t = 0:0.01:200;
            G = (exp(-0.1*t)+1).*cos(t);
            funcRes = utils.baselineAmplitude(t, G, 100);
            actSolution = 22*pi;
            verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
        end
        
        function testAmplitudeBaselineDamped(testCase)
            % Test baseline for (uncrticially) damped case
            % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
            % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
            % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
            % => t_min = 49.87 (determined using plot)
            t = 0:0.01:200;
            G = exp(-0.1*t).*cos(0.5*t)+1;
            funcRes = utils.baselineAmplitude(t, G, 100);
            actSolution = 53.01;
            verifyEqual(testCase,funcRes, actSolution, 'AbsTol', 0.01)
        end
        
        function testExponFitDamped(testCase)
            % Test baseline for (uncrticially) damped case
            % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
            % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
            % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
            % => t_min = 49.87 (determined using plot)
            t = 0:0.01:200;
            G = exp(-0.1*t)*0.5.*cos(0.5*t)+1;
            fit = utils.expon_fit(t, G, 100);
            actSolution = -0.1;
            verifyEqual(testCase,fit.b, actSolution, 'AbsTol', 0.01)
        end
        
        function testExponFitCritial(testCase)
            % Test baseline for (uncrticially) damped case
            % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
            % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
            % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
            % => t_min = 49.87 (determined using plot)
            t = 0:0.01:200;
            G = exp(-0.1*t)+1;
            fit = utils.expon_fit(t, G, 100);
            actSolution = -0.1;
            verifyEqual(testCase,fit.b, actSolution, 'AbsTol', 0.01)
        end
        
        function testExponFitLimit(testCase)
            % Test baseline for (uncrticially) damped case
            % Find first time peak of e^(-0.1t)cos(0.5t) is within 1% of 0.
            % Need t_min, s.t. G<0.001 of 0, after the final peak>0.001
            % i.e. first G<0.001, after final |e^(-0.1t)cos(0.5t)|>0.001, cos(0.5t)=1
            % => t_min = 49.87 (determined using plot)
            t = 0:0.01:200;
            G = (20000*exp(-0.1*t)+1).*cos(0.5*t);
            fit = utils.expon_fit(t, G, 100);
            actSolution = -0.1;
            verifyEqual(testCase,fit.b, actSolution, 'AbsTol', 0.01)
        end
        function rk4fixedStep(testCase)
            % Test rk4 solver on sine wave through equation
            % u'' = -u; y(0)=0
            % let v=u' then y = [u; v], y' =[v; -u] = [y(2) -y(1)] and y(0)=[0; 1]
            times = 0:0.1:10;
            dy = @(t, y, const) [y(2); -y(1)];
            yOut = utils.rk4Fixed(dy, [0 1], '', times, 2);
            solnExpected = sin(times);
            verifyEqual(testCase,yOut(:,1)', solnExpected, 'AbsTol', 0.01)
        end
        
        function iAUCTest(testCase)
            % test iAUC function on function with 5 t<10 and decay 5e(-(t-t_0) above 5
            % for t>10. I.e. a monotonic function
            
            % Expected area by integration approx 5.
            
            t = 0:0.01:30;
            y = 5*ones(1,length(t));
            y(t>=10) = y(t>=10)+5*exp(-(t(t>=10)-10));
            
            iAUC = utils.iAUC(y, t, t>=10);
            verifyEqual(testCase, iAUC, 5, 'AbsTol',1e-4)
        end
        
        function iAUCSin(testCase)
            % test iAUC function on function with 5 t<10 and function
            % sin(2pi t/10)*5e(-(t-t_0)+5
            % for t>10. I.e. a non-monotonic function
            
            % Expected area by integration approx 2.267 (using mathematica)
            
            t = 0:0.00001:30;
            y = 5*ones(1,length(t));
            tRel = t>=10;
            y(tRel) = y(tRel)+5*exp(-(t(tRel)-10)).*sin(2*pi*t(tRel)/10);
            
            iAUC = utils.iAUC(y, t, t>=10);
            verifyEqual(testCase, iAUC, 2.2676, 'AbsTol',1e-4)
        end
    end
end

