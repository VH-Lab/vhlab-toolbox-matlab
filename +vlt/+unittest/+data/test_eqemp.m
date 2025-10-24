classdef test_eqemp < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyTrue(vlt.data.eqemp([], []), 'Both empty should return true');
        end

        function test_one_empty_bug(testCase)
            % Test case where one input is empty
            % The function has a bug where it returns true if the first
            % argument is non-empty and the second is empty.
            testCase.verifyFalse(vlt.data.eqemp([], 5), 'First empty, second not should return false');
            testCase.verifyTrue(vlt.data.eqemp(5, []), 'BUG: First not, second empty should return true');
        end

        function test_both_nonempty_equal(testCase)
            % Test case where both inputs are non-empty and equal
            testCase.verifyTrue(vlt.data.eqemp(5, 5), 'Equal numbers should return true');
            testCase.verifyEqual(vlt.data.eqemp([1 2 3], [1 2 3]), logical([1 1 1]), 'Equal arrays should return logical true array');
        end

        function test_both_nonempty_unequal(testCase)
            % Test case where both inputs are non-empty and unequal
            testCase.verifyFalse(vlt.data.eqemp(5, 6), 'Unequal numbers should return false');
            testCase.verifyEqual(vlt.data.eqemp([1 2 3], [3 2 1]), logical([0 1 0]), 'Unequal arrays should return a logical array');
        end

        function test_different_sizes_error(testCase)
            % Test case where non-empty inputs have different sizes
            % This should error because of the `==` operator
            testCase.verifyError(@() vlt.data.eqemp([1 2], [1 2 3]), 'MATLAB:dimagree');
        end

    end
end
