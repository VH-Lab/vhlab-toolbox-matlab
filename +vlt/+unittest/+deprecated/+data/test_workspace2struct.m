classdef test_workspace2struct < matlab.unittest.TestCase
    % TEST_WORKSPACE2STRUCT - tests for the deprecated workspace2struct function
    %
    %

    properties
    end

    methods (Test)

        function test_workspace2struct_smoke(testCase)
            % define some variables
            a = 1;
            b = [ 1 2 3 ];
            c = 'mytest';

            % now call workspace2struct to capture them
            output = workspace2struct();

            % and verify the output
            testCase.verifyTrue(isstruct(output));

            % The 'who' command in the function will also grab the 'testCase' variable
            % so we expect it to be in the fieldnames.
            expected_fieldnames = {'a';'b';'c';'testCase'};
            % sort them because the order is not guaranteed
            testCase.verifyEqual(sort(fieldnames(output)), sort(expected_fieldnames));

            testCase.verifyEqual(output.a, a);
            testCase.verifyEqual(output.b, b);
            testCase.verifyEqual(output.c, c);
            testCase.verifyEqual(output.testCase, testCase);

        end % test_workspace2struct_smoke

        function test_workspace2struct_empty_in_test(testCase)
            % This test is tricky because the test method's workspace will always have 'testCase'.
            % We can't truly test a completely empty workspace from here,
            % but we can verify that ONLY testCase is returned when no other variables are defined.

            output = workspace2struct();

            % and verify the output
            testCase.verifyTrue(isstruct(output));
            expected_fieldnames = {'testCase'};
            testCase.verifyEqual(fieldnames(output), expected_fieldnames);
            testCase.verifyEqual(output.testCase, testCase);

        end % test_workspace2struct_empty_in_test

    end; % methods (Test)

end
