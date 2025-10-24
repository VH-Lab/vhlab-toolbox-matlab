classdef test_eqlen < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyTrue(eqlen([], []), 'Both empty should return true');
        end

        function test_one_empty(testCase)
            % Test case where one input is empty
            testCase.verifyFalse(eqlen([], 5), 'First empty, second not should return false');
            testCase.verifyFalse(eqlen(5, []), 'First not, second empty should return false');
        end

        function test_different_sizes(testCase)
            % Test case where inputs have different sizes
            testCase.verifyFalse(eqlen([1 2], [1 2 3]), 'Different sizes should return false');
        end

        function test_same_size_equal_content(testCase)
            % Test case where inputs have the same size and equal content
            testCase.verifyTrue(eqlen(5, 5), 'Equal scalars should return true');
            testCase.verifyTrue(eqlen([1 2 3], [1 2 3]), 'Equal arrays should return true');
        end

        function test_same_size_unequal_content(testCase)
            % Test case where inputs have the same size but unequal content
            testCase.verifyFalse(eqlen([1 2 3], [3 2 1]), 'Unequal arrays should return false');
        end

    end
end
