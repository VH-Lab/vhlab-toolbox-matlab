classdef eqempTest < matlab.unittest.TestCase
    methods (Test)
        function testBothEmpty(testCase)
            testCase.verifyTrue(logical(vlt.data.eqemp([], [])));
        end

        function testOneEmpty(testCase)
            testCase.verifyFalse(logical(vlt.data.eqemp([], [1 2])));
            testCase.verifyFalse(logical(vlt.data.eqemp([1 2], [])));
        end

        function testBothNonEmptyEqual(testCase)
            testCase.verifyTrue(all(logical(vlt.data.eqemp([1 2], [1 2]))));
        end

        function testBothNonEmptyNotEqual(testCase)
            testCase.verifyFalse(any(logical(vlt.data.eqemp([1 2], [3 4]))));
        end
    end
end
