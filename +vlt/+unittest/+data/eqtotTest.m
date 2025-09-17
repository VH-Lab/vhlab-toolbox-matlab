classdef eqtotTest < matlab.unittest.TestCase
    methods (Test)
        function testEqual(testCase)
            testCase.verifyTrue(vlt.data.eqtot([4 4 4], [4 4 4]));
            testCase.verifyTrue(vlt.data.eqtot([1], [1 1]));
        end

        function testUnequal(testCase)
            testCase.verifyFalse(vlt.data.eqtot([1 2 3], [4 5 6]));
        end

        function testEmpty(testCase)
            testCase.verifyTrue(vlt.data.eqtot([], []));
            testCase.verifyFalse(vlt.data.eqtot([], [1]));
        end
    end
end
