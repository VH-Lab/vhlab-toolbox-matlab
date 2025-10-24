classdef test_eqtot < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyTrue(eqtot([], []), 'Both empty should return true');
        end

        function test_one_empty_bug(testCase)
            % Test case where one input is empty
            testCase.verifyFalse(eqtot([], 5), 'First empty, second not should return false');
            testCase.verifyTrue(eqtot(5, []), 'BUG: First not, second empty should return true');
        end

        function test_different_sizes_error(testCase)
            % Test case where non-empty inputs have different sizes
            testCase.verifyError(@() eqtot([1 2], [1 2 3]), 'MATLAB:dimagree');
        end

        function test_same_size_equal_content(testCase)
            % Test case where inputs have the same size and equal content
            testCase.verifyTrue(eqtot(5, 5), 'Equal scalars should return true');
            testCase.verifyTrue(eqtot([1 2 3], [1 2 3]), 'Equal arrays should return true');
        end

        function test_same_size_partially_equal_content(testCase)
            % Test case where inputs are partially equal
            testCase.verifyFalse(eqtot([1 2 3], [3 2 1]), 'Partially equal arrays should return false');
        end

    end
end
