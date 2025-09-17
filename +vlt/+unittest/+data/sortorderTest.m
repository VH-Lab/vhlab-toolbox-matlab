classdef sortorderTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleVector(testCase)
            A = [3 2 1];
            I = vlt.data.sortorder(A);
            testCase.verifyEqual(I, [3; 2; 1]);
        end

        function testRepeatedElements(testCase)
            A = [3 1 2 1];
            I = vlt.data.sortorder(A);
            [~, expected_I] = sort(A);
            testCase.verifyEqual(I, expected_I);
        end

        function testDescending(testCase)
            A = [1 2 3];
            I = vlt.data.sortorder(A, 'descend');
            testCase.verifyEqual(I, [3; 2; 1]);
        end
    end
end
