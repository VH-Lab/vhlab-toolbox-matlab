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
            testCase.verifyError(@() vlt.data.columnize_struct(not_a_struct), '');
            % The original function just uses `error` without an ID, so we expect ''
        end

        function test_struct_array_with_nested_structs_bug(testCase)
            % This tests the potential bug case.
            % The original function is expected to fail here.
            % The test should verify that an error is thrown.
            s_in(1).a = 1;
            s_in(1).b = struct('c', 10);
            s_in(2).a = 2;
            s_in(2).b = struct('c', 20);
            s_in(3).a = 3;
            s_in(3).b = struct('c', 30);

            % The getfield on s_out.b will return multiple outputs,
            % causing isstruct to fail.
            testCase.verifyError(@() vlt.data.columnize_struct(s_in), '');
        end

    end
end
