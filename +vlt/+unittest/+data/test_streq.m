classdef test_streq < matlab.unittest.TestCase
    methods (Test)
        function test_streq_equal_strings(testCase)
            testCase.verifyTrue(logical(vlt.data.streq('hello', 'hello')));
        end

        function test_streq_unequal_strings(testCase)
            testCase.verifyFalse(logical(vlt.data.streq('hello', 'world')));
        end

        function test_streq_wildcard_end(testCase)
            testCase.verifyTrue(logical(vlt.data.streq('testing', 'test*')));
        end

        function test_streq_wildcard_start(testCase)
            testCase.verifyTrue(logical(vlt.data.streq('testing', '*ing')));
        end

        function test_streq_wildcard_middle(testCase)
            testCase.verifyTrue(logical(vlt.data.streq('testing', 't*ing')));
        end

        function test_streq_multiple_wildcards(testCase)
            testCase.verifyTrue(logical(vlt.data.streq('testing 123 go', 't*123*go')));
        end

        function test_streq_wildcard_fail(testCase)
            testCase.verifyFalse(logical(vlt.data.streq('testing', 't*z')));
        end

        function test_streq_empty_strings(testCase)
            testCase.verifyTrue(logical(vlt.data.streq('', '')));
            testCase.verifyFalse(logical(vlt.data.streq('a', '')));
            testCase.verifyTrue(logical(vlt.data.streq('', '*')));
        end

        function test_streq_custom_wildcard(testCase)
            testCase.verifyTrue(logical(vlt.data.streq('testing', 'test?ing', '?')));
            testCase.verifyFalse(logical(vlt.data.streq('testing', 'test*ing', '?')));
        end
    end
end
