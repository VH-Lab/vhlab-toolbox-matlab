classdef test_ismatlabstring < matlab.unittest.TestCase
    methods (Test)
        function test_simple_string(testCase)
            str = "myvar=5; a = 'my string';";
            res = vlt.string.ismatlabstring(str);
            expected = zeros(1, length(str));
            % 'my string' starts at index 14 and ends at index 24
            expected(14:24) = 1;
            testCase.verifyEqual(res, expected);
        end

        function test_no_string(testCase)
            str = 'a = 5 + 10;';
            res = vlt.string.ismatlabstring(str);
            testCase.verifyEqual(res, zeros(1, length(str)));
        end

        function test_escaped_quote(testCase)
            str = "a = 'hello ''world''';";
            res = vlt.string.ismatlabstring(str);
            expected = zeros(1, length(str));
            expected(5:21) = 1;
            testCase.verifyEqual(res, expected);
        end

        function test_startiswithinstring(testCase)
            str = "inside'; outside";
            res = vlt.string.ismatlabstring(str, 1);
            expected = zeros(1, length(str));
            expected(1:7) = 1;
            testCase.verifyEqual(res, expected);
        end
    end
end
