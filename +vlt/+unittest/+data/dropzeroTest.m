classdef dropzeroTest < matlab.unittest.TestCase
    methods (Test)
        function testVectorWithZeros(testCase)
            A = [1 2 0 4 5 0];
            B = vlt.data.dropzero(A);
            testCase.verifyEqual(B, [1 2 4 5]);
        end

        function testVectorWithNoZeros(testCase)
            A = [1 2 3 4 5];
            B = vlt.data.dropzero(A);
            testCase.verifyEqual(B, A);
        end

        function testVectorWithAllZeros(testCase)
            A = [0 0 0];
            B = vlt.data.dropzero(A);
            testCase.verifyEmpty(B);
        end

        function testEmptyVector(testCase)
            A = [];
            testCase.verifyError(@() vlt.data.dropzero(A), 'MATLAB:MException:Custom');
        end
    end
end
