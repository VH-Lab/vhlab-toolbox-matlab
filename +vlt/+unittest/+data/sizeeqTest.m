classdef sizeeqTest < matlab.unittest.TestCase
    methods (Test)
        function testSameSize(testCase)
            testCase.verifyTrue(vlt.data.sizeeq([1 2], [3 4]));
            testCase.verifyTrue(vlt.data.sizeeq([1; 2], [3; 4]));
        end

        function testDifferentSize(testCase)
            testCase.verifyFalse(vlt.data.sizeeq([1 2], [3 4 5]));
            testCase.verifyFalse(vlt.data.sizeeq([1 2], [3; 4]));
        end

        function testEmptyArrays(testCase)
            testCase.verifyTrue(vlt.data.sizeeq([], []));
            testCase.verifyFalse(vlt.data.sizeeq([], [1]));
        end
    end
end
