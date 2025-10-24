classdef test_equnique < matlab.unittest.TestCase

    methods (Test)

        function test_empty_input(testCase)
            % Test with an empty array
            testCase.verifyTrue(isempty(equnique([])), 'Empty input should result in empty output');
        end

        function test_numeric_vector(testCase)
            % Test with a numeric vector with duplicates
            input = [1 5 1 3 5];
            expected = [1; 5; 3];
            actual = equnique(input);
            testCase.verifyEqual(actual, expected, 'Numeric vector with duplicates failed');
        end

        function test_numeric_vector_no_duplicates(testCase)
            % Test with a numeric vector with no duplicates
            input = [1 5 3];
            expected = [1; 5; 3];
            actual = equnique(input);
            testCase.verifyEqual(actual, expected, 'Numeric vector with no duplicates failed');
        end

        function test_cell_array_of_strings(testCase)
            % Test with a cell array of strings
            input = {'apple', 'banana', 'apple', 'orange', 'banana'};
            expected = {'apple'; 'banana'; 'orange'};
            actual = equnique(input);
            testCase.verifyEqual(actual, expected, 'Cell array of strings failed');
        end

        function test_struct_array(testCase)
            % Test with a struct array
            A = struct('field1', 1, 'field2', 'a');
            B = struct('field1', 2, 'field2', 'b');
            C = struct('field1', 1, 'field2', 'a'); % Same as A
            input = [A, B, C];

            % Expected output should be a 2x1 struct array
            expected(1,1) = A;
            expected(2,1) = B;

            actual = equnique(input);
            testCase.verifyEqual(actual, expected, 'Struct array failed');
        end

        function test_output_is_column(testCase)
            % Verify that the output is a column vector
            input = [1 2 3];
            actual = equnique(input);
            testCase.verifyEqual(size(actual, 2), 1, 'Output should be a column vector');

            input_row_cell = {'a', 'b', 'a'};
            actual_cell = equnique(input_row_cell);
            testCase.verifyEqual(size(actual_cell, 2), 1, 'Output for cell array should be a column vector');
        end

    end
end
