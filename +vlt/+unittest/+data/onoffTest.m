classdef onoffTest < matlab.unittest.TestCase
    methods (Test)
        function testPositive(testCase)
            testCase.verifyEqual(vlt.data.onoff(1), 'on');
            testCase.verifyEqual(vlt.data.onoff(5), 'on');
        end

        function testZero(testCase)
            testCase.verifyEqual(vlt.data.onoff(0), 'off');
        end

        function testNegative(testCase)
            testCase.verifyEqual(vlt.data.onoff(-1), 'off');
            testCase.verifyEqual(vlt.data.onoff(-5), 'off');
        end
    end
end
