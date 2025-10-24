classdef test_str2nume < matlab.unittest.TestCase
    methods (Test)
        function test_str2nume_numeric_string(testCase)
            testCase.verifyEqual(vlt.data.str2nume('123'), 123);
        end

        function test_str2nume_empty_string(testCase)
            testCase.verifyEmpty(vlt.data.str2nume(''));
        end

        function test_str2nume_non_numeric_string(testCase)
            testCase.verifyEmpty(vlt.data.str2nume('abc'));
        end

        function test_str2nume_matrix_string(testCase)
            testCase.verifyEqual(vlt.data.str2nume('[1 2; 3 4]'), [1 2; 3 4]);
        end
    end
end
