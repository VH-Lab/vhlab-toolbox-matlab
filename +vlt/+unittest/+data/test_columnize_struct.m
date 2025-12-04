classdef test_columnize_struct < matlab.unittest.TestCase
    methods(Test)

        function test_simple_struct(testCase)
            % Test a simple scalar struct
            s_in = struct('a', 1, 'b', 2);
            s_out = vlt.data.columnize_struct(s_in);
            testCase.verifyEqual(size(s_out), [1 1]);
            testCase.verifyEqual(s_in, s_out);
        end

        function test_row_vector_struct(testCase)
            % Test a row vector of structs
            s_in(1) = struct('a', 1, 'b', 2);
            s_in(2) = struct('a', 3, 'b', 4);
            s_in(3) = struct('a', 5, 'b', 6);

            % make it a row vector
            s_in = reshape(s_in, 1, 3);
            testCase.verifyEqual(size(s_in), [1 3]);

            s_out = vlt.data.columnize_struct(s_in);

            % Expected output should be a column vector
            s_expected(1) = struct('a', 1, 'b', 2);
            s_expected(2) = struct('a', 3, 'b', 4);
            s_expected(3) = struct('a', 5, 'b', 6);
            s_expected = reshape(s_expected, 3, 1);

            testCase.verifyEqual(size(s_out), [3 1]);
            testCase.verifyEqual(s_out, s_expected);
        end

        function test_nested_struct(testCase)
            % Test a struct with a nested struct field
            s_in.a = 1;
            s_in.b = struct('c', 3, 'd', 4);

            s_out = vlt.data.columnize_struct(s_in);
            testCase.verifyEqual(size(s_out.b), [1 1]);
            testCase.verifyEqual(s_in, s_out);
        end

        function test_nested_row_vector_struct(testCase)
            % Test a struct with a nested row vector of structs
            s_in.a = 1;
            s_in.b(1) = struct('c', 3, 'd', 4);
            s_in.b(2) = struct('c', 5, 'd', 6);

            % make it a row vector
            s_in.b = reshape(s_in.b, 1, 2);
            testCase.verifyEqual(size(s_in.b), [1 2]);

            s_out = vlt.data.columnize_struct(s_in);

            % Expected nested struct should be a column vector
            s_expected.a = 1;
            s_expected.b(1) = struct('c', 3, 'd', 4);
            s_expected.b(2) = struct('c', 5, 'd', 6);
            s_expected.b = reshape(s_expected.b, 2, 1);

            testCase.verifyEqual(size(s_out.b), [2 1]);
            testCase.verifyEqual(s_out, s_expected);
        end

        function test_non_struct_input_error(testCase)
            % Test that non-struct input throws an error
            not_a_struct = [1 2 3];
            % With arguments block, this throws a validation error
            testCase.verifyError(@() vlt.data.columnize_struct(not_a_struct), ?MException);
        end

        function test_struct_array_with_nested_structs_fixed(testCase)
            % This tests the previously buggy case where recursing on struct fields
            % in a struct array would fail.
            s_in(1).a = 1;
            s_in(1).b = struct('c', 10);
            s_in(2).a = 2;
            s_in(2).b = struct('c', 20);
            s_in(3).a = 3;
            s_in(3).b = struct('c', 30);

            s_out = vlt.data.columnize_struct(s_in);

            testCase.verifyEqual(size(s_out), [3 1]);
            % Verify the nested struct fields are preserved (and correct)
            testCase.verifyEqual(s_out(2).b.c, 20);

            % Expected result is just the columnized version of input
            s_expected = s_in(:);
            testCase.verifyEqual(s_out, s_expected);
        end

        function test_columnizeNumericVectors(testCase)
            % Test the columnizeNumericVectors option
            s_in.a = [1 2 3];
            s_in.b = 'hello'; % char array, not numeric
            s_in.c = struct('d', [4 5]);
            s_in.e = [1; 2; 3]; % already column
            s_in.f = [1 2; 3 4]; % matrix, not vector

            % Default behavior (false)
            s_out = vlt.data.columnize_struct(s_in);
            testCase.verifyEqual(s_out.a, [1 2 3]);
            testCase.verifyEqual(s_out.c.d, [4 5]);
            testCase.verifyEqual(s_out.b, 'hello');

            % Enabled behavior (true)
            s_out = vlt.data.columnize_struct(s_in, 'columnizeNumericVectors', true);

            % Check conversion
            testCase.verifyEqual(s_out.a, [1; 2; 3]);
            % Check recursive conversion
            testCase.verifyEqual(s_out.c.d, [4; 5]);
            % Check non-numeric unchanged
            testCase.verifyEqual(s_out.b, 'hello');
            % Check already column unchanged
            testCase.verifyEqual(s_out.e, [1; 2; 3]);
            % Check matrix unchanged
            testCase.verifyEqual(s_out.f, [1 2; 3 4]);
        end

    end
end
