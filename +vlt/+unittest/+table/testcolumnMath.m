classdef testcolumnMath < matlab.unittest.TestCase
    % TESTCOLUMNMATH - Test class for the vlt.table.columnMath function.
    %
    %   This class contains unit tests for the vlt.table.columnMath function,
    %   which performs mathematical operations on table columns. The tests cover
    %   basic arithmetic, function calls, error handling for invalid inputs,
    %   and edge cases.
    %
    %   See also: vlt.table.columnMath
    %

    properties
        SampleTable % A sample table for use in the tests
    end

    methods(TestMethodSetup)
        function createSampleTable(testCase)
            % Creates a consistent sample table before each test method runs.
            testCase.SampleTable = table([1; 2; 3; 4; 5], [10; 20; 30; 40; 50], ...
                'VariableNames', {'ColA', 'ColB'});
        end
    end

    methods(Test)
        function testBasicArithmetic(testCase)
            % Tests basic arithmetic operations like addition and squaring.

            % 1. Test squaring a column
            tbl_out = vlt.table.columnMath(testCase.SampleTable, 'ColA', 'ColASquared', 'X.^2');
            expected = [1; 4; 9; 16; 25];
            testCase.verifyEqual(tbl_out.ColASquared, expected, ...
                'Squaring operation did not produce the expected result.');

            % 2. Test adding a constant
            tbl_out = vlt.table.columnMath(testCase.SampleTable, 'ColB', 'ColBPlusTen', 'X + 10');
            expected = [20; 30; 40; 50; 60];
            testCase.verifyEqual(tbl_out.ColBPlusTen, expected, ...
                'Addition operation did not produce the expected result.');
        end

        function testFunctionOperations(testCase)
            % Tests operations that involve calling MATLAB functions.

            % 1. Test log10 transform
            tbl_out = vlt.table.columnMath(testCase.SampleTable, 'ColB', 'LogColB', 'log10(X)');
            expected = [1; log10(20); log10(30); log10(40); log10(50)];
            testCase.verifyEqual(tbl_out.LogColB, expected, 'AbsTol', 1e-9, ...
                'log10 operation did not produce the expected result.');

            % 2. Test Z-score
            data = testCase.SampleTable.ColA;
            op = '(X - mean(X)) / std(X)';
            tbl_out = vlt.table.columnMath(testCase.SampleTable, 'ColA', 'ZScoreColA', op);
            expected_zscore = (data - mean(data)) / std(data);
            testCase.verifyEqual(tbl_out.ZScoreColA, expected_zscore, 'AbsTol', 1e-9, ...
                'Z-score operation did not produce the expected result.');
        end

        function testErrorHandling(testCase)
            % Tests that the function correctly throws errors for invalid inputs.

            % 1. Test with a non-existent column name
            testCase.verifyError(@() vlt.table.columnMath(testCase.SampleTable, 'NonExistentCol', 'NewCol', 'X'), ...
                'vlt:validators:mustBeAValidTableVariable:notFound', ...
                'Did not error for a non-existent source column.');

            % 2. Test with an invalid operation string
            testCase.verifyError(@() vlt.table.columnMath(testCase.SampleTable, 'ColA', 'NewCol', 'invalid_function(X)'), ...
                'vlt:table:columnMath:invalidOp', ...
                'Did not error for an invalid operation string.');

            % 3. Test with a syntactically incorrect operation string
             testCase.verifyError(@() vlt.table.columnMath(testCase.SampleTable, 'ColA', 'NewCol', 'X +'), ...
                'vlt:table:columnMath:invalidOp', ...
                'Did not error for a syntactically incorrect op string.');
        end

        function testOverwritingColumn(testCase)
            % Tests that the function can overwrite an existing column.
            tbl_out = vlt.table.columnMath(testCase.SampleTable, 'ColA', 'ColA', 'X * 100');
            expected = [100; 200; 300; 400; 500];
            testCase.verifyEqual(tbl_out.ColA, expected, ...
                'Overwriting a column did not work as expected.');
            % Verify the other column is untouched
            testCase.verifyEqual(tbl_out.ColB, testCase.SampleTable.ColB, ...
                 'The non-target column was altered during an overwrite operation.');
        end

    end
end
