classdef testCell2Group < matlab.unittest.TestCase

    methods (Test)

        function testBasicColumnVectors(testCase)
            % Test with a cell array of column vectors
            a = { [1 2 3]', [4 5 6]', [7 8 9]' };
            [x, group] = vlt.data.cell2group(a);

            expected_x = [1 2 3 4 5 6 7 8 9]';
            expected_group = [1 1 1 2 2 2 3 3 3]';

            testCase.verifyEqual(x, expected_x, 'The concatenated data vector is incorrect.');
            testCase.verifyEqual(group, expected_group, 'The group identity vector is incorrect.');
        end

        function testMixedRowAndColumnVectors(testCase)
            % Test with a mix of row and column vectors
            a = { [1 2 3], [4 5 6]', [7 8] };
            [x, group] = vlt.data.cell2group(a);

            expected_x = [1 2 3 4 5 6 7 8]';
            expected_group = [1 1 1 2 2 2 3 3]';

            testCase.verifyEqual(x, expected_x, 'The concatenated data vector is incorrect for mixed vector types.');
            testCase.verifyEqual(group, expected_group, 'The group identity vector is incorrect for mixed vector types.');
        end

        function testEmptyCell(testCase)
            % Test with an empty cell
            a = {[]};
            [x, group] = vlt.data.cell2group(a);

            testCase.verifyEmpty(x, 'X should be empty for an empty cell.');
            testCase.verifyEmpty(group, 'Group should be empty for an empty cell.');
        end

        function testEmptyCellArray(testCase)
            % Test with an empty cell array
            a = {};
            [x, group] = vlt.data.cell2group(a);

            testCase.verifyEmpty(x, 'X should be empty for an empty cell array.');
            testCase.verifyEmpty(group, 'Group should be empty for an empty cell array.');
        end

    end
end