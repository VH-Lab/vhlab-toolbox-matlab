classdef test_eqemp < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyEqual(double(eqemp([], [])), 1, 'Both empty should return 1');
        end

        function test_one_empty(testCase)
            % Test case where exactly one input is empty.
            % The empty check must be symmetric. It previously tested
            % (xe&~ye) twice, so eqemp(5,[]) matched neither branch and kept
            % the b=1 initialiser. See issue #137, item 1.
            testCase.verifyEqual(double(eqemp([], 5)), 0, 'First empty, second not should return 0');
            testCase.verifyEqual(double(eqemp(5, [])), 0, 'First not, second empty should return 0');
        end

        function test_one_empty_symmetry(testCase)
            % Emptiness comparison must not depend on argument order.
            cases = { 5, [1 2 3], 'abc', {1,2} };
            for i=1:numel(cases),
                testCase.verifyEqual(double(eqemp(cases{i}, [])), ...
                    double(eqemp([], cases{i})), ...
                    'eqemp must give the same answer regardless of which argument is empty');
            end;
        end

        function test_both_nonempty_equal(testCase)
            % Test case where both inputs are non-empty and equal
            testCase.verifyEqual(double(eqemp(5, 5)), 1, 'Equal numbers should return 1');
            testCase.verifyEqual(double(eqemp([1 2 3], [1 2 3])), [1 1 1], 'Equal arrays should return double array of 1s');
        end

        function test_both_nonempty_unequal(testCase)
            % Test case where both inputs are non-empty and unequal
            testCase.verifyEqual(double(eqemp(5, 6)), 0, 'Unequal numbers should return 0');
            testCase.verifyEqual(double(eqemp([1 2 3], [3 2 1])), [0 1 0], 'Unequal arrays should return a double array');
        end

        function test_different_sizes_error(testCase)
            % Test case where non-empty inputs have different sizes
            % This should error because of the `==` operator
            testCase.verifyError(@() eqemp([1 2], [1 2 3]), 'MATLAB:sizeDimensionsMustMatch');
        end

        function test_cell_comparison_uses_toolbox_overload(testCase)
            % Issue #137 item 2. The old help said an error results when X==Y
            % is undefined. Not so here: datastructures/@cell/eq.m defines ==
            % for cells and vlt_Init puts it on the path, so this returns a
            % value rather than throwing. Guards both the behaviour and the
            % dependency -- if the legacy tree were retired, this would fail
            % rather than silently changing eqemp's contract.
            testCase.verifyEqual(double(eqemp({'r','g','b'}, {'r','g','b'})), 1, ...
                'Equal cell arrays should compare equal, not error');
            testCase.verifyEqual(double(eqemp({'r','g','b'}, {'r','g','x'})), 0, ...
                'Differing cell arrays should compare unequal, not error');
        end

    end
end
