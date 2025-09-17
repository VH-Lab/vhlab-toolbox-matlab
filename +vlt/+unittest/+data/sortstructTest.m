classdef sortstructTest < matlab.unittest.TestCase
    properties
        s
    end

    methods (TestMethodSetup)
        function createStruct(testCase)
            testCase.s = vlt.data.emptystruct('a','b');
            testCase.s(1) = struct('a', 1, 'b', 10);
            testCase.s(2) = struct('a', 2, 'b', 5);
            testCase.s(3) = struct('a', 1, 'b', 20);
        end
    end

    methods (Test)
        function testSortOneFieldAscending(testCase)
            [~, indexes] = vlt.data.sortstruct(testCase.s, '+a');
            testCase.verifyEqual(indexes, [1; 3; 2]);
        end

        function testSortOneFieldDescending(testCase)
            [~, indexes] = vlt.data.sortstruct(testCase.s, '-b');
            testCase.verifyEqual(indexes, [3; 1; 2]);
        end

        function testSortTwoFields(testCase)
            [~, indexes] = vlt.data.sortstruct(testCase.s, '+a', '-b');
            testCase.verifyEqual(indexes, [3; 1; 2]);
        end
    end
end
