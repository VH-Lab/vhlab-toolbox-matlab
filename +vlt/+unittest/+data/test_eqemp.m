classdef test_eqemp < matlab.unittest.TestCase

    methods (Test)

        function test_both_empty(testCase)
            % Test case where both inputs are empty
            testCase.verifyEqual(double(vlt.data.eqemp([], [])), 1, 'Both empty should return 1');
        end

        function test_one_empty(testCase)
            % Test case where exactly one input is empty.
            % The empty check must be symmetric. It previously tested
            % (xe&~ye) twice, so eqemp(5,[]) matched neither branch and kept
            % the b=1 initialiser. See issue #137, item 1.
            testCase.verifyEqual(double(vlt.data.eqemp([], 5)), 0, 'First empty, second not should return 0');
            testCase.verifyEqual(double(vlt.data.eqemp(5, [])), 0, 'First not, second empty should return 0');
        end

        function test_one_empty_symmetry(testCase)
            % Emptiness comparison must not depend on argument order.
            cases = { 5, [1 2 3], 'abc', {1,2} };
            for i=1:numel(cases),
                testCase.verifyEqual(double(vlt.data.eqemp(cases{i}, [])), ...
                    double(vlt.data.eqemp([], cases{i})), ...
                    'eqemp must give the same answer regardless of which argument is empty');
            end;
        end

        function test_both_nonempty_equal(testCase)
            % Test case where both inputs are non-empty and equal
            testCase.verifyEqual(double(vlt.data.eqemp(5, 5)), 1, 'Equal numbers should return 1');
            testCase.verifyEqual(double(vlt.data.eqemp([1 2 3], [1 2 3])), [1 1 1], 'Equal arrays should return double array of 1s');
        end

        function test_both_nonempty_unequal(testCase)
            % Test case where both inputs are non-empty and unequal
            testCase.verifyEqual(double(vlt.data.eqemp(5, 6)), 0, 'Unequal numbers should return 0');
            testCase.verifyEqual(double(vlt.data.eqemp([1 2 3], [3 2 1])), [0 1 0], 'Unequal arrays should return a double array');
        end

        function test_different_sizes_error(testCase)
            % Test case where non-empty inputs have different sizes
            % This should error because of the `==` operator
            testCase.verifyError(@() vlt.data.eqemp([1 2], [1 2 3]), 'MATLAB:sizeDimensionsMustMatch');
        end

        function test_cell_inputs_error(testCase)
            % Issue #137, item 2. The help says a comparison with no defined ==
            % is an error, and MATLAB does not define == for cell arrays. That
            % had only ever been inferred; this pins it on a real release so
            % the help text and the behaviour cannot drift apart.
            testCase.verifyError(@() vlt.data.eqemp({'r','g','b'}, {'r','g','b'}), ...
                'MATLAB:UndefinedFunction', ...
                'eqemp on two cell arrays must raise, since == is undefined for cells');
        end

    end
end
