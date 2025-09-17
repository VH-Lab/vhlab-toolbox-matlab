classdef isempty_cellTest < matlab.unittest.TestCase
    methods (Test)
        function testMixed(testCase)
            A = {'test', [] ; [] 'more text'};
            B = vlt.data.isempty_cell(A);
            testCase.verifyEqual(B, [0 1; 1 0]);
        end

        function testAllEmpty(testCase)
            A = {[], []};
            B = vlt.data.isempty_cell(A);
            testCase.verifyEqual(B, [1 1]);
        end

        function testAllNonEmpty(testCase)
            A = {'a', 'b'};
            B = vlt.data.isempty_cell(A);
            testCase.verifyEqual(B, [0 0]);
        end

        function testEmptyInput(testCase)
            A = {};
            B = vlt.data.isempty_cell(A);
            testCase.verifyEmpty(B);
        end
    end
end
