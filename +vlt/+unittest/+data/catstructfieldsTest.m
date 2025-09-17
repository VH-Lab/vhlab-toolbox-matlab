classdef catstructfieldsTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleConcatenation(testCase)
            a.field1 = [1 2 3];
            a.field2 = [1 2 3];
            b.field1 = [4 5 6];
            b.field2 = [4 5 6];
            c = vlt.data.catstructfields(a, b);
            testCase.verifyEqual(c.field1, [1 2 3 4 5 6]);
            testCase.verifyEqual(c.field2, [1 2 3 4 5 6]);
        end

        function testDimConcatenation(testCase)
            a.field1 = [1; 2; 3];
            a.field2 = [1; 2; 3];
            b.field1 = [4; 5; 6];
            b.field2 = [4; 5; 6];
            c = vlt.data.catstructfields(a, b, 1);
            testCase.verifyEqual(c.field1, [1; 2; 3; 4; 5; 6]);
            testCase.verifyEqual(c.field2, [1; 2; 3; 4; 5; 6]);
        end

        function testMismatchedFieldnames(testCase)
            a.field1 = 1;
            b.field2 = 2;
            testCase.verifyError(@() vlt.data.catstructfields(a, b), ?MException);
        end
    end
end
