classdef eqempTest < matlab.unittest.TestCase
    methods (Test)
        function testBothEmpty(testCase)
            testCase.verifyTrue(vlt.data.eqemp([], []));
        end

        function testOneEmpty(testCase)
            testCase.verifyFalse(vlt.data.eqemp([], [1 2]));
            testCase.verifyFalse(vlt.data.eqemp([1 2], []));
        end

        function testBothNonEmptyEqual(testCase)
            testCase.verifyTrue(all(vlt.data.eqemp([1 2], [1 2])));
        end

        function testBothNonEmptyNotEqual(testCase)
            testCase.verifyFalse(all(vlt.data.eqemp([1 2], [3 4])));
        end
    end
end
