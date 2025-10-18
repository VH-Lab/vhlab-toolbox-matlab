classdef testCell2str < matlab.unittest.TestCase

    methods (Test)

        function testEmptyCell(testCase)
            % Test with an empty cell
            A = {};
            str = cell2str(A);
            testCase.verifyEqual(str, '{}');
        end

        function testCellWithStrings(testCase)
            % Test with a cell array of strings
            A = {'test1', 'test2', 'test3'};
            str = cell2str(A);
            B = eval(str);
            testCase.verifyEqual(A, B);
        end

        function testCellWithNumeric(testCase)
            % Test with a cell array of numeric values
            A = {1, [2 3], 4};
            str = cell2str(A);
            B = eval(str);
            testCase.verifyEqual(A, B);
        end

        function testCellWithMixedTypes(testCase)
            % Test with a cell array of mixed types
            A = {'test1', 1, [2 3]};
            str = cell2str(A);
            B = eval(str);
            testCase.verifyEqual(A, B);
        end

    end

end