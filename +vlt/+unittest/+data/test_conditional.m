classdef test_conditional < matlab.unittest.TestCase
    % TEST_CONDITIONAL - tests for the vlt.data.conditional function
    %
    %

    properties
    end

    methods (Test)

        function test_conditional_basic(testCase)
            % test the conditional function

            % Test 1: test is > 0, should return 'a'
            c = vlt.data.conditional(1, 'a', 'b');
            testCase.verifyEqual(c, 'a');

            % Test 2: test is 0, should return 'b'
            c = vlt.data.conditional(0, 'a', 'b');
            testCase.verifyEqual(c, 'b');

            % Test 3: test is a logical true, should return 'a'
            c = vlt.data.conditional(true, 'a', 'b');
            testCase.verifyEqual(c, 'a');

            % Test 4: test is a logical false, should return 'b'
            c = vlt.data.conditional(false, 'a', 'b');
            testCase.verifyEqual(c, 'b');

            % Test 5: test is a negative number, should return 'b'
            c = vlt.data.conditional(-1, 'a', 'b');
            testCase.verifyEqual(c, 'b');

        end % test_conditional_basic

    end; % methods (Test)

end
