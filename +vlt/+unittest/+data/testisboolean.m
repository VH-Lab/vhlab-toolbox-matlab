classdef testisboolean < matlab.unittest.TestCase
    % testisboolean - tests for vlt.data.isboolean
    %
    %

    properties
    end

    methods (Test)

        function test_isboolean_logical(testCase)
            testCase.verifyTrue(logical(vlt.data.isboolean([true false true])));
        end

        function test_isboolean_numeric(testCase)
            testCase.verifyTrue(logical(vlt.data.isboolean([1 0 1])));
        end

        function test_isboolean_mixed(testCase)
            testCase.verifyFalse(logical(vlt.data.isboolean([1 0 2])));
        end

        function test_isboolean_not_numeric(testCase)
            testCase.verifyFalse(logical(vlt.data.isboolean('hello')));
            testCase.verifyFalse(logical(vlt.data.isboolean({true, false})));
        end

        function test_isboolean_empty(testCase)
            testCase.verifyTrue(logical(vlt.data.isboolean([])));
        end

    end
end
