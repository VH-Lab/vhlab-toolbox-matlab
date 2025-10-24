classdef test_onoff < matlab.unittest.TestCase
    % TEST_ONOFF - tests for the onoff function

    methods (Test)

        function test_onoff_basic(testCase)
            % Test with numeric values
            testCase.verifyEqual(onoff(1), 'on');
            testCase.verifyEqual(onoff(5), 'on');
            testCase.verifyEqual(onoff(0), 'off');
            testCase.verifyEqual(onoff(-1), 'off');
        end

        function test_onoff_logical(testCase)
            % Test with logical values
            testCase.verifyEqual(onoff(true), 'on');
            testCase.verifyEqual(onoff(false), 'off');
        end

    end; % methods (Test)

end
