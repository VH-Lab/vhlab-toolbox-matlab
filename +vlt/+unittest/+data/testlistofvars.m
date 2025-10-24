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
            testCase.verifyTrue(all(ismember(expected_doubles, var_list_double)), 'Not all expected double variables were found.');

            % Test for 'char' class
            var_list_char = vlt.data.listofvars('char');
            expected_chars = {'test_char_var'};
            testCase.verifyTrue(all(ismember(expected_chars, var_list_char)), 'Not all expected char variables were found.');

            % Test for 'struct' class
            var_list_struct = vlt.data.listofvars('struct');
            expected_structs = {'test_struct_var'};
            testCase.verifyTrue(all(ismember(expected_structs, var_list_struct)), 'Not all expected struct variables were found.');

            % Test for a class that has no variables created by the test
            % We can't guarantee another variable of this type doesn't exist,
            % so we can't test for emptiness directly. Instead we could
            % check that our specific test variables of other types are NOT in a list
            % of this type, but that is less direct. For now, we'll remove the emptiness test
            % as it is prone to failure in a non-isolated environment.

            % Verify that 'ans' is never returned, regardless of type
            var_list = vlt.data.listofvars('char'); % check any list
            testCase.verifyFalse(any(strcmp(var_list, 'ans')), "'ans' variable was returned when it should have been ignored.");
        end
    end
end
