classdef test_cellarray2mat < matlab.unittest.TestCase
    % Tests for vlt.data.cellarray2mat

    methods (Test)

        function test_example_case(testCase)
            % Test the example provided in the function's help text
            c{1} = [1 2 3];
            c{2} = [4 5];
            expected = [1 4; 2 5; 3 NaN];
            result = vlt.data.cellarray2mat(c);
            testCase.verifyEqual(result, expected, 'AbsTol', 1e-9, 'The example case did not produce the expected matrix.');
        end

        function test_empty_input(testCase)
            % Test with an empty cell array
            c = {};
            expected = [];
            result = vlt.data.cellarray2mat(c);
            testCase.verifyEqual(result, expected, 'An empty input cell array should produce an empty matrix.');
        end

        function test_with_empty_cell(testCase)
            % Test with a cell array containing an empty cell
            c{1} = [10; 20];
            c{2} = [];
            c{3} = [30; 40; 50];
            expected = [10 NaN 30; 20 NaN 40; NaN NaN 50];
            result = vlt.data.cellarray2mat(c);
            testCase.verifyEqual(result, expected, 'AbsTol', 1e-9, 'The function did not handle an empty cell correctly.');
        end

        function test_row_and_column_vectors(testCase)
            % Test with a mix of row and column vectors
            c{1} = [1 2 3];   % row vector
            c{2} = [4; 5];    % column vector
            c{3} = [6 7];     % row vector
            expected = [1 4 6; 2 5 7; 3 NaN NaN];
            result = vlt.data.cellarray2mat(c);
            testCase.verifyEqual(result, expected, 'AbsTol', 1e-9, 'The function did not handle a mix of row and column vectors correctly.');
        end

        function test_error_on_matrix_input_cell(testCase)
            % Test that the function errors if a cell contains a matrix
            c{1} = [1 2];
            c{2} = [3 4; 5 6]; % matrix, not a vector

            % The original function uses a generic error, so we catch the message
            testCase.verifyError(@() vlt.data.cellarray2mat(c), 'MATLAB:UndefinedFunction', ...
                'The function should throw an error for non-vector cell entries.');
        end

        function test_error_on_non_vector_input(testCase)
            % Test that the function errors if the input C is not a vector
            c = {[1 2], [3 4]; [5 6], [7 8]}; % 2x2 cell array

            % The original function uses a generic error, so we catch the message
            testCase.verifyError(@() vlt.data.cellarray2mat(c), 'MATLAB:UndefinedFunction', ...
                'The function should throw an error for non-vector cell array inputs.');
        end

    end
end