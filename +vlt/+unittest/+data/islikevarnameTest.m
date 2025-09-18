classdef islikevarnameTest < matlab.unittest.TestCase
    methods (Test)
        function testValidName(testCase)
            [b, e] = vlt.data.islikevarname('my_var');
            testCase.verifyTrue(logical(b));
            testCase.verifyEmpty(e);
        end

        function testStartsWithNumber(testCase)
            [b, e] = vlt.data.islikevarname('1my_var');
            testCase.verifyFalse(logical(b));
            testCase.verifyNotEmpty(e);
        end

        function testContainsWhitespace(testCase)
            [b, e] = vlt.data.islikevarname('my var');
            testCase.verifyTrue(logical(b));
            testCase.verifyEmpty(e);
        end

        function testEmptyName(testCase)
            [b, e] = vlt.data.islikevarname('');
            testCase.verifyFalse(logical(b));
            testCase.verifyNotEmpty(e);
        end

        function testNonChar(testCase)
            [b, e] = vlt.data.islikevarname(123);
            testCase.verifyFalse(logical(b));
            testCase.verifyNotEmpty(e);
        end
    end
end
