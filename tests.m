function testOut = tests
    testOut = functiontests(localfunctions);
end

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

