classdef testlistofvars < matlab.unittest.TestCase
    % TESTLISTOFVARS - test the vlt.data.listofvars function

    properties
    end

    methods (Test)
        function testFunctionality(testCase)
            % Create some variables in the base workspace for testing
            test_double_var = 5;
            test_char_var = 'hello';
            test_struct_var = struct('a', 1);
            test_another_double = [1 2 3];
            ans = 'should be ignored';

            assignin('base', 'test_double_var', test_double_var);
            assignin('base', 'test_char_var', test_char_var);
            assignin('base', 'test_struct_var', test_struct_var);
            assignin('base', 'test_another_double', test_another_double);
            assignin('base', 'ans', ans);

            % Use addTeardown for cleanup to ensure it runs even if tests fail
            testCase.addTeardown(@() evalin('base', 'clear test_double_var test_char_var test_struct_var test_another_double ans'));

            % Test for 'double' class
            var_list_double = vlt.data.listofvars('double');
            expected_doubles = {'test_double_var', 'test_another_double'};
            testCase.verifyEqual(sort(var_list_double), sort(expected_doubles));

            % Test for 'char' class
            var_list_char = vlt.data.listofvars('char');
            testCase.verifyEqual(var_list_char, {'test_char_var'});

            % Test for 'struct' class
            var_list_struct = vlt.data.listofvars('struct');
            testCase.verifyEqual(var_list_struct, {'test_struct_var'});

            % Test for a class that has no variables in the workspace
            var_list_none = vlt.data.listofvars('nonexistentclass');
            testCase.verifyTrue(isempty(var_list_none));

            % Verify that 'ans' is never returned, regardless of type
            var_list_char_no_ans = vlt.data.listofvars('char');
            testCase.verifyFalse(any(strcmp(var_list_char_no_ans, 'ans')));
        end
    end
end
