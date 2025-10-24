classdef test_sortstruct < matlab.unittest.TestCase
    methods (Test)
        function test_sortstruct_single_field_asc(testCase)
            s(1).test1 = 2; s(1).test2 = 'b';
            s(2).test1 = 1; s(2).test2 = 'a';
            s(3).test1 = 3; s(3).test2 = 'c';

            [~, indexes] = vlt.data.sortstruct(s, '+test1');
            testCase.verifyEqual(indexes, [2; 1; 3]);
        end

        function test_sortstruct_single_field_desc(testCase)
            s(1).test1 = 2; s(1).test2 = 'b';
            s(2).test1 = 1; s(2).test2 = 'a';
            s(3).test1 = 3; s(3).test2 = 'c';

            [~, indexes] = vlt.data.sortstruct(s, '-test1');
            testCase.verifyEqual(indexes, [3; 1; 2]);
        end

        function test_sortstruct_multi_field(testCase)
            s(1).test1 = 1; s(1).test2 = 5;
            s(2).test1 = 1; s(2).test2 = 4;
            s(3).test1 = 2; s(3).test2 = 1;

            [~, indexes] = vlt.data.sortstruct(s, '+test1', '+test2');
            testCase.verifyEqual(indexes, [2; 1; 3]);
        end

        function test_sortstruct_multi_field_mixed_sign(testCase)
            s(1).test1 = 1; s(1).test2 = 4;
            s(2).test1 = 1; s(2).test2 = 5;
            s(3).test1 = 2; s(3).test2 = 1;

            [~, indexes] = vlt.data.sortstruct(s, '+test1', '-test2');
            testCase.verifyEqual(indexes, [2; 1; 3]);
        end

        function test_sortstruct_string_field(testCase)
            s(1).test1 = 'b';
            s(2).test1 = 'c';
            s(3).test1 = 'a';
            [~, indexes] = vlt.data.sortstruct(s, '+test1');
            testCase.verifyEqual(indexes, [3; 1; 2]);
        end
    end
end
