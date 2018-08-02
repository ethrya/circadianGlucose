% Test class definition
classdef utilsTests < matlab.unittest.TestCase
    methods (Test)
        
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

