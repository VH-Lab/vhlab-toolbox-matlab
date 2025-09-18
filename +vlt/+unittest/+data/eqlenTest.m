classdef eqlenTest < matlab.unittest.TestCase
    methods (Test)
        function testEqualSizeAndContent(testCase)
            testCase.verifyTrue(logical(vlt.data.eqlen([1 2], [1 2])));
            testCase.verifyTrue(logical(vlt.data.eqlen([], [])));
        end

        function testDifferentSize(testCase)
            testCase.verifyFalse(logical(vlt.data.eqlen([1 2], [1 2 3])));
            testCase.verifyFalse(logical(vlt.data.eqlen([1 2], [1; 2])));
        end

        function testSameSizeDifferentContent(testCase)
            testCase.verifyFalse(logical(vlt.data.eqlen([1 2], [3 4])));
        end
    end
end
