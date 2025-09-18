classdef dropnanTest < matlab.unittest.TestCase
    methods (Test)
        function testVectorWithNaNs(testCase)
            A = [1 2 NaN 4 5 NaN];
            B = vlt.data.dropnan(A);
            testCase.verifyEqual(B, [1 2 4 5]);
        end

        function testVectorWithNoNaNs(testCase)
            A = [1 2 3 4 5];
            B = vlt.data.dropnan(A);
            testCase.verifyEqual(B, A);
        end

        function testVectorWithAllNaNs(testCase)
            A = [NaN NaN NaN];
            B = vlt.data.dropnan(A);
            testCase.verifyEmpty(B);
        end

        function testEmptyVector(testCase)
            A = [];
            testCase.verifyError(@() vlt.data.dropnan(A), 'MATLAB:MException:Custom');
        end
    end
end
