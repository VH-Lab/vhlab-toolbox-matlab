classdef conditionalTest < matlab.unittest.TestCase
    methods (Test)
        function testTrue(testCase)
            C = vlt.data.conditional(1, 'a', 'b');
            testCase.verifyEqual(C, 'a');
        end

        function testFalseZero(testCase)
            C = vlt.data.conditional(0, 'a', 'b');
            testCase.verifyEqual(C, 'b');
        end

        function testFalseNegative(testCase)
            C = vlt.data.conditional(-1, 'a', 'b');
            testCase.verifyEqual(C, 'b');
        end
    end
end
