classdef test_nonbsp < matlab.unittest.TestCase

    methods (Test)

        function test_nonbsp_basic(testCase)
            % Create a table with various data types
            nbsp = char(160);

            T_in = table(...
                string({'hello' nbsp 'world'; 'another' nbsp 'string'}), ... % string array
                {['cell' nbsp 'str']; ['another' nbsp 'cell']}, ...           % cell array of chars
                ['char' nbsp 'array  '; 'another' nbsp 'char'], ...           % char array
                [1; 2], ...                                                 % numeric
                [true; false], ...                                          % logical
                'VariableNames', {'StringCol', 'CellStrCol', 'CharCol', 'NumericCol', 'LogicalCol'}...
            );

            % Expected output table
            T_expected = table(...
                ["hello world"; "another string"], ...
                {'cell str'; 'another cell'}, ...
                ['char array  '; 'another char'], ... % Note: strtrim would be needed for trailing space
                [1; 2], ...
                [true; false], ...
                'VariableNames', {'StringCol', 'CellStrCol', 'CharCol', 'NumericCol', 'LogicalCol'}...
            );

            % Run the function
            T_out = vlt.table.nonbsp(T_in);

            % Verify the results
            testCase.verifyEqual(T_out.StringCol, T_expected.StringCol, 'String column was not corrected.');
            testCase.verifyEqual(T_out.CellStrCol, T_expected.CellStrCol, 'Cell string column was not corrected.');
            % Char arrays are tricky, need to compare row by row if not padded equally
            testCase.verifyEqual(T_out.CharCol, T_expected.CharCol, 'Char column was not corrected.');
            testCase.verifyEqual(T_out.NumericCol, T_expected.NumericCol, 'Numeric column was modified.');
            testCase.verifyEqual(T_out.LogicalCol, T_expected.LogicalCol, 'Logical column was modified.');
        end

    end
end
