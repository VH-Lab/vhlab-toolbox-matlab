classdef listofvarsTest < matlab.unittest.TestCase
    methods (TestMethodSetup)
        function createBaseWorkspaceVars(testCase)
            assignin('base', 'test_var_a', 5);
            assignin('base', 'test_var_b', 'hello');
            assignin('base', 'test_var_c', [1 2 3]);
        end
    end

    methods (TestMethodTeardown)
        function clearBaseWorkspaceVars(testCase)
            evalin('base', 'clear test_var_a test_var_b test_var_c');
        end
    end

    methods (Test)
        function testListOfDoubles(testCase)
            double_vars = vlt.data.listofvars('double');
            testCase.verifyTrue(any(strcmp(double_vars, 'test_var_a')));
            testCase.verifyTrue(any(strcmp(double_vars, 'test_var_c')));
            testCase.verifyFalse(any(strcmp(double_vars, 'test_var_b')));
        end

        function testListOfChars(testCase)
            char_vars = vlt.data.listofvars('char');
            testCase.verifyTrue(any(strcmp(char_vars, 'test_var_b')));
            testCase.verifyFalse(any(strcmp(char_vars, 'test_var_a')));
        end
    end
end
