classdef testisint < matlab.unittest.TestCase
    % testisint - tests for isint (deprecated)
    %
    %

    properties
    end

    methods (Test)

        function test_isint_true(testCase)
            testCase.verifyTrue(logical(isint([1 2 3])));
            testCase.verifyTrue(logical(isint([-5 0 10])));
            testCase.verifyTrue(logical(isint(5)));
        end

        function test_isint_false(testCase)
            testCase.verifyFalse(logical(isint([1.1 2 3])));
            testCase.verifyFalse(logical(isint('hello')));
            testCase.verifyFalse(logical(isint({1 2 3})));
        end

        function test_isint_empty(testCase)
            testCase.verifyTrue(logical(isint([])));
        end

        function test_isint_special_numeric(testCase)
            testCase.verifyFalse(logical(isint([1 2 NaN])));
            testCase.verifyFalse(logical(isint([1 2 Inf])));
        end

    end
end
