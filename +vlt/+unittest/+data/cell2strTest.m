classdef cell2strTest < matlab.unittest.TestCase
    methods (Test)
        function testStringCell(testCase)
            A = {'test','test2','test3'};
            str = vlt.data.cell2str(A);
            testCase.verifyEqual(str, '{ ''test'', ''test2'', ''test3'' }');
            B = eval(str);
            testCase.verifyEqual(A, B);
        end

        function testNumericCell(testCase)
            A = {1, 2, 3};
            str = vlt.data.cell2str(A);
            testCase.verifyEqual(str, '{ [1], [2], [3] }');
            B = eval(str);
            testCase.verifyEqual(A, B);
        end

        function testMixedCell(testCase)
            A = {'test', 1, [2 3]};
            str = vlt.data.cell2str(A);
            testCase.verifyEqual(str, '{ ''test'', [1], [2 3] }');
            B = eval(str);
            testCase.verifyEqual(A, B);
        end

        function testEmptyCell(testCase)
            A = {};
            str = vlt.data.cell2str(A);
            testCase.verifyEqual(str, '{}');
            B = eval(str);
            testCase.verifyEqual(A, B);
        end
    end
end
