classdef testispos < matlab.unittest.TestCase
    % testispos - tests for vlt.data.ispos
    %
    %

    properties
    end

    methods (Test)

        function test_ispos_true(testCase)
            testCase.verifyTrue(logical(vlt.data.ispos([1 2 3])));
            testCase.verifyTrue(logical(vlt.data.ispos(5)));
            testCase.verifyTrue(logical(vlt.data.ispos([0.1 0.2 0.3])));
        end

        function test_ispos_false(testCase)
            testCase.verifyFalse(logical(vlt.data.ispos([-1 2 3])));
            testCase.verifyFalse(logical(vlt.data.ispos([0 1 2])));
            testCase.verifyFalse(logical(vlt.data.ispos('hello')));
            testCase.verifyFalse(logical(vlt.data.ispos({1 2 3})));
        end

        function test_ispos_empty(testCase)
            testCase.verifyTrue(logical(vlt.data.ispos([])));
        end

        function test_ispos_special_numeric(testCase)
            testCase.verifyFalse(logical(vlt.data.ispos([1 2 NaN])));
            testCase.verifyTrue(logical(vlt.data.ispos([1 2 Inf])));
        end

    end
end
