classdef test_var2struct < matlab.unittest.TestCase
    % TEST_VAR2STRUCT - tests for the vlt.data.var2struct function
    %
    %

    properties
    end

    methods (Test)

        function test_var2struct_smoke(testCase)
            % define some variables
            a = 1;
            b = [ 1 2 3 ];
            c = 'mytest';

            % now call var2struct to capture them
            output = vlt.data.var2struct('a', 'b', 'c');

            % and verify the output
            testCase.verifyTrue(isstruct(output));
            testCase.verifyEqual(fieldnames(output), {'a';'b';'c'});
            testCase.verifyEqual(output.a, a);
            testCase.verifyEqual(output.b, b);
            testCase.verifyEqual(output.c, c);
        end % test_var2struct_smoke

        function test_var2struct_empty(testCase)
            % test with no variables
            output = vlt.data.var2struct();
            testCase.verifyTrue(isstruct(output));
            testCase.verifyTrue(isempty(fieldnames(output)));
        end % test_var2struct_empty

    end; % methods (Test)

end
