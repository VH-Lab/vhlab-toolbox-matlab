classdef test_onoff < matlab.unittest.TestCase
    % TEST_ONOFF - tests for the vlt.data.onoff function

    methods (Test)

        function test_onoff_basic(testCase)
            % Test with numeric values
            testCase.verifyEqual(vlt.data.onoff(1), 'on');
            testCase.verifyEqual(vlt.data.onoff(5), 'on');
            testCase.verifyEqual(vlt.data.onoff(0), 'off');
            testCase.verifyEqual(vlt.data.onoff(-1), 'off');
        end

        function test_onoff_logical(testCase)
            % Test with logical values
            testCase.verifyEqual(vlt.data.onoff(true), 'on');
            testCase.verifyEqual(vlt.data.onoff(false), 'off');
        end

    end; % methods (Test)

end
