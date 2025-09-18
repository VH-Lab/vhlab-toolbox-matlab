classdef eqtotTest < matlab.unittest.TestCase
    methods (Test)
        function testEqual(testCase)
            testCase.verifyTrue(logical(vlt.data.eqtot([4 4 4], [4 4 4])));
            testCase.verifyTrue(logical(vlt.data.eqtot([1], [1 1])));
        end

        function testUnequal(testCase)
            testCase.verifyFalse(logical(vlt.data.eqtot([1 2 3], [4 5 6])));
        end

        function testEmpty(testCase)
            testCase.verifyTrue(logical(vlt.data.eqtot([], [])));
            testCase.verifyFalse(logical(vlt.data.eqtot([], [1])));
        end
    end
end
