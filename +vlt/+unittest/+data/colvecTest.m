classdef colvecTest < matlab.unittest.TestCase
    methods (Test)
        function testMatrix(testCase)
            A = [1 2; 3 4];
            Y = vlt.data.colvec(A);
            testCase.verifyTrue(iscolumn(Y));
            testCase.verifyEqual(Y, [1; 3; 2; 4]);
        end

        function testRowVector(testCase)
            A = [1 2 3];
            Y = vlt.data.colvec(A);
            testCase.verifyTrue(iscolumn(Y));
            testCase.verifyEqual(Y, [1; 2; 3]);
        end

        function testColumnVector(testCase)
            A = [1; 2; 3];
            Y = vlt.data.colvec(A);
            testCase.verifyTrue(iscolumn(Y));
            testCase.verifyEqual(Y, [1; 2; 3]);
        end
    end
end
