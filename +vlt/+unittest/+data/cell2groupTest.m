classdef cell2groupTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleCase(testCase)
            a = {[1 2 3]', [4 5 6]', [7 8 9]'};
            [x, group] = vlt.data.cell2group(a);
            testCase.verifyEqual(x, [1 2 3 4 5 6 7 8 9]');
            testCase.verifyEqual(group, [1 1 1 2 2 2 3 3 3]');
        end

        function testEmptyCell(testCase)
            a = {[], [1 2 3]'};
            [x, group] = vlt.data.cell2group(a);
            testCase.verifyEqual(x, [1 2 3]');
            testCase.verifyEqual(group, [2 2 2]');
        end

        function testEmptyInput(testCase)
            a = {};
            [x, group] = vlt.data.cell2group(a);
            testCase.verifyEmpty(x);
            testCase.verifyEmpty(group);
        end
    end
end
