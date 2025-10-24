classdef test_valid_varname < matlab.unittest.TestCase
    methods(Test)
        function test_valid_names(testCase)
            % Test with valid variable names
            testCase.verifyTrue(logical(vlt.data.valid_varname('a')));
            testCase.verifyTrue(logical(vlt.data.valid_varname('myVar')));
            testCase.verifyTrue(logical(vlt.data.valid_varname('my_var')));
            testCase.verifyTrue(logical(vlt.data.valid_varname('myVar123')));
        end

        function test_invalid_names(testCase)
            % Test with invalid variable names
            testCase.verifyFalse(logical(vlt.data.valid_varname('1var')));
            testCase.verifyFalse(logical(vlt.data.valid_varname('my var')));
            testCase.verifyFalse(logical(vlt.data.valid_varname('my-var')));
            testCase.verifyFalse(logical(vlt.data.valid_varname('my!var')));
            testCase.verifyFalse(logical(vlt.data.valid_varname('end')));
        end
    end
end
