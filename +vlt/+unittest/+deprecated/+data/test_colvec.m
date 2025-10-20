classdef test_colvec < matlab.unittest.TestCase
    % TEST_COLVEC - test the deprecated colvec function

    methods (Test)
        function test_matrix_input(testCase)
            % Test with a 2D matrix
            a = [1 2 3; 4 5 6];
            b = colvec(a);
            expected = [1; 4; 2; 5; 3; 6];
            testCase.verifyEqual(b, expected, 'The matrix was not correctly converted to a column vector.');
            testCase.verifySize(b, [6 1]);
        end

        function test_row_vector_input(testCase)
            % Test with a row vector
            a = [1 2 3 4];
            b = colvec(a);
            expected = [1; 2; 3; 4];
            testCase.verifyEqual(b, expected, 'The row vector was not correctly converted to a column vector.');
            testCase.verifySize(b, [4 1]);
        end

        function test_col_vector_input(testCase)
            % Test with a column vector (should be unchanged)
            a = [1; 2; 3; 4];
            b = colvec(a);
            testCase.verifyEqual(b, a, 'The column vector was unexpectedly changed.');
            testCase.verifySize(b, [4 1]);
        end
    end
end
