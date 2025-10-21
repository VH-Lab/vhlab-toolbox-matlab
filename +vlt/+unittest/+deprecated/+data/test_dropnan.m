classdef test_dropnan < matlab.unittest.TestCase
    % TEST_DROPNAN - test the deprecated dropnan function

    methods (Test)
        function test_row_vector_input(testCase)
            % Test with a row vector containing NaNs
            a = [1 NaN 3 4 NaN 6];
            b = dropnan(a);
            expected = [1 3 4 6];
            testCase.verifyEqual(b, expected, 'The NaNs were not correctly dropped from the row vector.');
            testCase.verifySize(b, [1 4]);
        end

        function test_col_vector_input(testCase)
            % Test with a column vector containing NaNs
            a = [1; NaN; 3; 4; NaN; 6];
            b = dropnan(a);
            expected = [1; 3; 4; 6];
            testCase.verifyEqual(b, expected, 'The NaNs were not correctly dropped from the column vector.');
            testCase.verifySize(b, [4 1]);
        end

        function test_no_nan_input(testCase)
            % Test with a vector containing no NaNs
            a = [1 2 3 4];
            b = dropnan(a);
            testCase.verifyEqual(b, a, 'The vector was unexpectedly changed.');
        end

        function test_all_nan_input(testCase)
            % Test with a vector containing only NaNs
            a = [NaN NaN NaN];
            b = dropnan(a);
            testCase.verifyTrue(isempty(b), 'The vector was not empty after dropping all NaNs.');
        end

        function test_empty_input(testCase)
            % Test with an empty vector
            a = [];
            b = dropnan(a);
            testCase.verifyEqual(b, a, 'The empty vector was unexpectedly changed.');
        end

        function test_matrix_input_error(testCase)
            % Test that a matrix input throws an error
            a = [1 2; 3 4];
            testCase.verifyError(@() dropnan(a), 'MATLAB:validation:mustBeVector', 'A matrix input did not throw the expected error.');
        end
    end
end
