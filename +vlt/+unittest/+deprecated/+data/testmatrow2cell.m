classdef testmatrow2cell < matlab.unittest.TestCase
    % TESTMATROW2CELL - test the matrow2cell function

    properties
    end

    methods (Test)
        function testNumericMatrix(testCase)
            % Test a standard numeric matrix
            mat = [1 2 3; 4 5 6; 7 8 9];
            c = matrow2cell(mat);
            expected = {[1 2 3], [4 5 6], [7 8 9]};
            testCase.verifyEqual(c, expected);
        end

        function testSingleRowMatrix(testCase)
            % Test a matrix with a single row
            mat = [10 20 30];
            c = matrow2cell(mat);
            testCase.verifyEqual(c, {[10 20 30]});
        end

        function testSingleColumnMatrix(testCase)
            % Test a matrix with a single column
            mat = [10; 20; 30];
            c = matrow2cell(mat);
            expected = {10; 20; 30};
            % The function creates a row cell array, so we need to transpose the expected result for comparison.
            testCase.verifyEqual(c, expected');
        end

        function testEmptyMatrix(testCase)
            % Test an empty matrix
            mat = [];
            c = matrow2cell(mat);
            testCase.verifyTrue(iscell(c) && isempty(c));
        end

        function testCellInput(testCase)
            % Test when the input is already a cell array
            inputCell = {'a', [1 2], struct('x', 5)};
            outputCell = matrow2cell(inputCell);
            testCase.verifyEqual(outputCell, inputCell);
        end

        function testCharMatrix(testCase)
            % Test a character matrix
            mat = ['ab'; 'cd'; 'ef'];
            c = matrow2cell(mat);
            expected = {'ab', 'cd', 'ef'};
            testCase.verifyEqual(c, expected);
        end
    end
end
