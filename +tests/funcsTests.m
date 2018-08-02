% Test class definition
classdef funcsTests < matlab.unittest.TestCase
    methods (Test)
        
        
        function testF1Default(testCase)
            const = models.constants;
            G = 10000;
            actSolution = models.funcs.f1(G, const);
            sigSlope = -const.Vg*const.a1; sigMax = const.Rm;
            sigShift = const.C1/const.a1;
            expSolution = models.funcs.sigmoid(G, sigMax, sigSlope, sigShift);
            verifyEqual(testCase,actSolution,expSolution)
        end
        
        function testF1Alternative(testCase)
            const = models.constants;
            const.Vg = 5; const.Rm = 100; C1 = -3000;
            G = -10000;
            actSolution = models.funcs.f1(G, const);
            sigSlope = -const.Vg*const.a1; sigMax = const.Rm;
            sigShift = const.C1/const.a1;
            expSolution = models.funcs.sigmoid(G, sigMax, sigSlope, sigShift);
            verifyEqual(testCase,actSolution,expSolution)
        end
        
        function testF2Default(testCase)
            const = models.constants;
            G = 10000;
            actSolution = models.funcs.f2(G, const);
            expSolution = const.Ub*(1-exp(-G/(const.C2*const.Vg)));
            verifyEqual(testCase,actSolution,expSolution)
        end
        
        function testF2Alternative(testCase)
            const = models.constants;
            const.Vg = 5; const.Ub = 100; C2 = -3000;
            G = -10000;
            actSolution = models.funcs.f2(G, const);
            expSolution = const.Ub*(1-exp(-G/(const.C2*const.Vg)));
            verifyEqual(testCase,actSolution,expSolution)
        end
        
        function testF3Default(testCase)
            const = models.constants;
            G = 10000;
            actSolution = models.funcs.f3(G, const);
            expSolution = G/(const.C3*const.Vg);
            verifyEqual(testCase,actSolution,expSolution)
        end
        
        function testF3Alternative(testCase)
            const = models.constants;
            const.Vg = 5; C3 = -3000;
            G = 10;
            actSolution = models.funcs.f3(G, const);
            expSolution = G/(const.C3*const.Vg);
            verifyEqual(testCase,actSolution,expSolution)
        end
        
    end
end

