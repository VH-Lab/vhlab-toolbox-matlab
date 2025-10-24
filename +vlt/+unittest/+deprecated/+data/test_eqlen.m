classdef test_eqlen < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyEqual(eqlen([], []), 1, 'Both empty should return 1');
        end

        function test_one_empty(testCase)
            % Test case where one input is empty
            testCase.verifyEqual(eqlen([], 5), 0, 'First empty, second not should return 0');
            testCase.verifyEqual(eqlen(5, []), 0, 'First not, second empty should return 0');
        end

        function test_different_sizes(testCase)
            % Test case where inputs have different sizes
            testCase.verifyEqual(eqlen([1 2], [1 2 3]), 0, 'Different sizes should return 0');
        end

        function test_same_size_equal_content(testCase)
            % Test case where inputs have the same size and equal content
            testCase.verifyEqual(eqlen(5, 5), 1, 'Equal scalars should return 1');
            testCase.verifyEqual(eqlen([1 2 3], [1 2 3]), 1, 'Equal arrays should return 1');
        end

        function test_same_size_unequal_content(testCase)
            % Test case where inputs have the same size but unequal content
            testCase.verifyEqual(eqlen([1 2 3], [3 2 1]), 0, 'Unequal arrays should return 0');
        end

    end
end
