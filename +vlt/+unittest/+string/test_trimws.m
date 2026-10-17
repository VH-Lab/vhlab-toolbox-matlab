classdef test_trimws < matlab.unittest.TestCase
    methods (Test)
        function test_leading_whitespace(testCase)
            str = '   hello world';
            res = vlt.string.trimws(str);
            testCase.verifyEqual(res, 'hello world');
        end

        function test_no_whitespace(testCase)
            str = 'hello world';
            res = vlt.string.trimws(str);
            testCase.verifyEqual(res, 'hello world');
        end

        function test_trailing_whitespace_preserved(testCase)
            str = '   hello world   ';
            res = vlt.string.trimws(str);
            testCase.verifyEqual(res, 'hello world   ');
        end

        function test_empty_string(testCase)
            str = '';
            res = vlt.string.trimws(str);
            testCase.verifyEqual(res, '');
        end

        function test_only_whitespace(testCase)
            str = '     ';
            res = vlt.string.trimws(str);
            testCase.verifyEqual(res, '');
        end
    end
end
