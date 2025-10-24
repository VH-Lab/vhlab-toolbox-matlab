classdef testislikevarname < matlab.unittest.TestCase
    % testislikevarname - tests for islikevarname (deprecated)
    %
    %

    properties
    end

    methods (Test)

        function test_islikevarname_valid(testCase)
            [b, errormsg] = islikevarname('myVar');
            testCase.verifyTrue(logical(b));
            testCase.verifyEmpty(errormsg);
        end

        function test_islikevarname_starts_with_number(testCase)
            [b, ~] = islikevarname('1myVar');
            testCase.verifyFalse(logical(b));
        end

        function test_islikevarname_has_whitespace(testCase)
            [b, ~] = islikevarname('my Var');
            testCase.verifyFalse(logical(b));
        end

        function test_islikevarname_empty_string(testCase)
            [b, ~] = islikevarname('');
            testCase.verifyFalse(logical(b));
        end

        function test_islikevarname_not_a_string(testCase)
            [b, ~] = islikevarname(5);
            testCase.verifyFalse(logical(b));
        end

    end
end
