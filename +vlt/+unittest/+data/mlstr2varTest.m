classdef mlstr2varTest < matlab.unittest.TestCase
    methods (Test)
        function testCellArray(testCase)
            C = {'test', 5, [3 4 5]};
            str = vlt.data.cell2mlstr(C);
            C_reconstructed = vlt.data.mlstr2var(str);
            testCase.verifyEqual(C, C_reconstructed);
        end

        function testStruct(testCase)
            S.a = 1;
            S.b = 'hello';
            str = vlt.data.struct2mlstr(S);
            S_reconstructed = vlt.data.mlstr2var(str);
            testCase.verifyEqual(S, S_reconstructed);
        end

        function testNestedStruct(testCase)
            S.a = 1;
            S.b = 'hello';
            S2.c = {1, 2};
            S.c = S2;
            str = vlt.data.struct2mlstr(S);
            S_reconstructed = vlt.data.mlstr2var(str);
            testCase.verifyEqual(S, S_reconstructed);
        end
    end
end
