classdef test_eqemp < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyEqual(eqemp([], []), 1, 'Both empty should return 1');
        end

        function test_one_empty_bug(testCase)
            % Test case where one input is empty
            % The function has a bug where it returns true if the first
            % argument is non-empty and the second is empty.
            testCase.verifyEqual(eqemp([], 5), 0, 'First empty, second not should return 0');
            testCase.verifyEqual(eqemp(5, []), 1, 'BUG: First not, second empty should return 1');
        end

        function test_both_nonempty_equal(testCase)
            % Test case where both inputs are non-empty and equal
            testCase.verifyEqual(eqemp(5, 5), 1, 'Equal numbers should return 1');
            testCase.verifyEqual(eqemp([1 2 3], [1 2 3]), [1 1 1], 'Equal arrays should return double array of 1s');
        end

        function test_both_nonempty_unequal(testCase)
            % Test case where both inputs are non-empty and unequal
            testCase.verifyEqual(eqemp(5, 6), 0, 'Unequal numbers should return 0');
            testCase.verifyEqual(eqemp([1 2 3], [3 2 1]), [0 1 0], 'Unequal arrays should return a double array');
        end

        function test_different_sizes_error(testCase)
            % Test case where non-empty inputs have different sizes
            % This should error because of the `==` operator
            testCase.verifyError(@() eqemp([1 2], [1 2 3]), 'MATLAB:sizeDimensionsMustMatch');
        end

    end
end
