classdef equniqueTest < matlab.unittest.TestCase
    methods (Test)
        function testNumericVector(testCase)
            A = [1 2 2 3 1 4];
            B = vlt.data.equnique(A);
            testCase.verifyEqual(sort(B), [1; 2; 3; 4]);
        end

        function testStructArray(testCase)
            S.a = 1; S.b = 2;
            A = [S S S];
            B = vlt.data.equnique(A);
            testCase.verifyEqual(length(B), 1);
            testCase.verifyEqual(B, S);
        end

        function testCellArrayOfStrings(testCase)
            A = {'a', 'b', 'a', 'c'};
            B = vlt.data.equnique(A);
            testCase.verifyEqual(sort(B), {'a'; 'b'; 'c'});
        end
    end
end
