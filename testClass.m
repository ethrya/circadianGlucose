% Test class definition
classdef testClass < matlab.unittest.TestCase
    methods (Test)
        function rk4fixedStep(testCase)
            % Test rk4 solver on sine wave through equation
            % u'' = -u; y(0)=0
            % let v=u' then y = [u; v], y' =[v; -u] = [y(2) -y(1)] and y(0)=[0; 1]
            times = 0:0.1:10;
            dy = @(t, y, const) [y(2); -y(1)];
            yOut = utils.rk4Fixed(dy, [0 1], '', times, 2);
            solnExpected = sin(times)';
            testCase.verifyEqual(yOut(:,1), solnExpected, 'AbsTol', 0.01)
        end
    end
end