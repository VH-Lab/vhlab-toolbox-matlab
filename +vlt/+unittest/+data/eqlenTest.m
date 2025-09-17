classdef eqlenTest < matlab.unittest.TestCase
    methods (Test)
        function testEqualSizeAndContent(testCase)
            testCase.verifyTrue(vlt.data.eqlen([1 2], [1 2]));
            testCase.verifyTrue(vlt.data.eqlen([], []));
        end

        function testDifferentSize(testCase)
            testCase.verifyFalse(vlt.data.eqlen([1 2], [1 2 3]));
            testCase.verifyFalse(vlt.data.eqlen([1 2], [1; 2]));
        end

        function testSameSizeDifferentContent(testCase)
            testCase.verifyFalse(vlt.data.eqlen([1 2], [3 4]));
        end
    end
end
