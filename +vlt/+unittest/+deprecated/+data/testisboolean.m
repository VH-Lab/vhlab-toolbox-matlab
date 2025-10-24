classdef testisboolean < matlab.unittest.TestCase
    % testisboolean - tests for isboolean (deprecated)
    %
    %

    properties
    end

    methods (Test)

        function test_isboolean_logical(testCase)
            testCase.verifyTrue(logical(isboolean([true false true])));
        end

        function test_isboolean_numeric(testCase)
            testCase.verifyTrue(logical(isboolean([1 0 1])));
        end

        function test_isboolean_mixed(testCase)
            testCase.verifyFalse(logical(isboolean([1 0 2])));
        end

        function test_isboolean_not_numeric(testCase)
            testCase.verifyFalse(logical(isboolean('hello')));
            testCase.verifyFalse(logical(isboolean({true, false})));
        end

        function test_isboolean_empty(testCase)
            testCase.verifyTrue(logical(isboolean([])));
        end

    end
end
