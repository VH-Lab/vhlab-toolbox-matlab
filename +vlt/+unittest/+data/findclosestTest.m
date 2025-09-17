classdef findclosestTest < matlab.unittest.TestCase
    methods (Test)
        function testSimple(testCase)
            array = [1 5 10 15];
            value = 6;
            [i, v] = vlt.data.findclosest(array, value);
            testCase.verifyEqual(i, 2);
            testCase.verifyEqual(v, 5);
        end

        function testExactMatch(testCase)
            array = [1 5 10 15];
            value = 10;
            [i, v] = vlt.data.findclosest(array, value);
            testCase.verifyEqual(i, 3);
            testCase.verifyEqual(v, 10);
        end

        function testMultipleOccurrences(testCase)
            array = [1 5 5 10];
            value = 6;
            [i, v] = vlt.data.findclosest(array, value);
            testCase.verifyEqual(i, 2);
            testCase.verifyEqual(v, 5);
        end

        function testEmptyArray(testCase)
            array = [];
            value = 5;
            [i, v] = vlt.data.findclosest(array, value);
            testCase.verifyEmpty(i);
            testCase.verifyEmpty(v);
        end
    end
end
