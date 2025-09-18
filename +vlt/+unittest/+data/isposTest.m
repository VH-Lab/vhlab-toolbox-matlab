classdef isposTest < matlab.unittest.TestCase
    methods (Test)
        function testPositive(testCase)
            testCase.verifyTrue(logical(vlt.data.ispos([1 2 3])));
            testCase.verifyTrue(logical(vlt.data.ispos(5)));
        end

        function testZero(testCase)
            testCase.verifyFalse(logical(vlt.data.ispos([1 0 3])));
        end

        function testNegative(testCase)
            testCase.verifyFalse(logical(vlt.data.ispos([-1 2 3])));
        end

        function testNonNumeric(testCase)
            testCase.verifyFalse(logical(vlt.data.ispos('hello')));
        end
    end
end
