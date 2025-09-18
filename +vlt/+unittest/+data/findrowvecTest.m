classdef findrowvecTest < matlab.unittest.TestCase
    methods (Test)
        function testSimple(testCase)
            A = [1 2 3; 4 5 6; 1 2 3];
            B = [1 2 3];
            I = vlt.data.findrowvec(A, B);
            testCase.verifyEqual(I, [1; 3]);
        end

        function testNoMatch(testCase)
            A = [1 2 3; 4 5 6; 1 2 3];
            B = [7 8 9];
            I = vlt.data.findrowvec(A, B);
            testCase.verifyEmpty(I);
        end

        function testEmptyMatrix(testCase)
            A = [];
            B = [1 2 3];
            testCase.verifyError(@() vlt.data.findrowvec(A, B), 'MATLAB:MException:Custom');
        end
    end
end
