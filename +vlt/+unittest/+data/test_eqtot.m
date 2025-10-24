classdef test_eqtot < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyEqual(vlt.data.eqtot([], []), 1, 'Both empty should return 1');
        end

        function test_one_empty_bug(testCase)
            % Test case where one input is empty
            testCase.verifyEqual(vlt.data.eqtot([], 5), 0, 'First empty, second not should return 0');
            testCase.verifyEqual(vlt.data.eqtot(5, []), 1, 'BUG: First not, second empty should return 1');
        end

        function test_different_sizes_error(testCase)
            % Test case where non-empty inputs have different sizes
            testCase.verifyError(@() vlt.data.eqtot([1 2], [1 2 3]), 'MATLAB:sizeDimensionsMustMatch');
        end

        function test_same_size_equal_content(testCase)
            % Test case where inputs have the same size and equal content
            testCase.verifyEqual(vlt.data.eqtot(5, 5), 1, 'Equal scalars should return 1');
            testCase.verifyEqual(vlt.data.eqtot([1 2 3], [1 2 3]), 1, 'Equal arrays should return 1');
        end

        function test_same_size_partially_equal_content(testCase)
            % Test case where inputs are partially equal
            testCase.verifyEqual(vlt.data.eqtot([1 2 3], [3 2 1]), 0, 'Partially equal arrays should return 0');
        end

    end
end
