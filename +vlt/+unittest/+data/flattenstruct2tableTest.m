classdef flattenstruct2tableTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            S = struct('A', 1, 'B', 2);
            T = vlt.data.flattenstruct2table(S);
            testCase.verifyEqual(T.A, 1);
            testCase.verifyEqual(T.B, 2);
        end

        function testNestedStruct(testCase)
            S = struct('A', struct('X', 1, 'Y', 2), 'B', 3);
            T = vlt.data.flattenstruct2table(S);
            testCase.verifyEqual(T.('A.X'), 1);
            testCase.verifyEqual(T.('A.Y'), 2);
            testCase.verifyEqual(T.B, 3);
        end

        function testNestedStructArray(testCase)
            Sub = struct('X', {10, 20}, 'Y', {'a', 'b'});
            S = struct('A', Sub, 'C', 3);
            T = vlt.data.flattenstruct2table(S);
            testCase.verifyTrue(iscell(T.('A.X')));
            testCase.verifyEqual(T.('A.X'){1}, 10);
            testCase.verifyTrue(iscell(T.('A.Y')));
            testCase.verifyEqual(T.('A.Y'){1}, 'a');
            testCase.verifyEqual(T.C, 3);
        end

        function testAbbreviations(testCase)
            S = struct('long_name_A', 1, 'long_name_B', 2);
            abbrev = {{'long_name_', ''}};
            T = vlt.data.flattenstruct2table(S, abbrev);
            testCase.verifyEqual(T.A, 1);
            testCase.verifyEqual(T.B, 2);
        end
    end
end
