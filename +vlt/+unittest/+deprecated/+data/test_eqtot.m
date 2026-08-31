classdef test_eqtot < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyEqual(eqtot([], []), 1, 'Both empty should return 1');
        end

        function test_one_empty(testCase)
            % Test case where exactly one input is empty.
            % eqtot inherits eqemp's empty handling, which was asymmetric:
            % eqtot(5,[]) and eqtot([1 2],[]) both returned 1. See issue
            % #137, item 1.
            testCase.verifyEqual(eqtot([], 5), 0, 'First empty, second not should return 0');
            testCase.verifyEqual(eqtot(5, []), 0, 'First not, second empty should return 0');
            testCase.verifyEqual(eqtot([1 2], []), 0, 'Non-empty vs empty should return 0');
            testCase.verifyEqual(eqtot([], [1 2]), 0, 'Empty vs non-empty should return 0');
        end

        function test_different_sizes_error(testCase)
            % Test case where non-empty inputs have different sizes
            testCase.verifyError(@() eqtot([1 2], [1 2 3]), 'MATLAB:sizeDimensionsMustMatch');
        end

        function test_same_size_equal_content(testCase)
            % Test case where inputs have the same size and equal content
            testCase.verifyEqual(eqtot(5, 5), 1, 'Equal scalars should return 1');
            testCase.verifyEqual(eqtot([1 2 3], [1 2 3]), 1, 'Equal arrays should return 1');
        end

        function test_same_size_partially_equal_content(testCase)
            % test case where inputs are partially equal
            testCase.verifyEqual(eqtot([1 2 3], [3 2 1]), 0, 'partially equal arrays should return 0');
        end

    end
end
