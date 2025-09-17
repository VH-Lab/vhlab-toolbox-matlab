classdef catCellStrTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleConcatenation(testCase)
            mycell = {'hello', 'world'};
            mystr = vlt.data.catCellStr(mycell);
            testCase.verifyEqual(mystr, ' hello world');
        end

        function testEmptyCellArray(testCase)
            mycell = {};
            mystr = vlt.data.catCellStr(mycell);
            testCase.verifyEqual(mystr, '');
        end

        function testSingleElementCellArray(testCase)
            mycell = {'test'};
            mystr = vlt.data.catCellStr(mycell);
            testCase.verifyEqual(mystr, ' test');
        end
    end
end
