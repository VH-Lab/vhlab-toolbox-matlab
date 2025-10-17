classdef test_catstructfields < matlab.unittest.TestCase
    methods(Test)
        function test_simple_concatenation(testCase)
            % Test simple concatenation of two structures
            s1 = struct('a', 1, 'b', 2);
            s2 = struct('a', 3, 'b', 4);
            s_cat = catstructfields(s1, s2);

            expected_a = [1; 3];
            expected_b = [2; 4];

            testCase.verifyEqual(s_cat.a, expected_a);
            testCase.verifyEqual(s_cat.b, expected_b);
        end

        function test_mismatched_fields(testCase)
            % Test that an error is thrown for mismatched field names
            s1 = struct('a', 1, 'b', 2);
            s2 = struct('a', 3, 'c', 4);

            testCase.verifyError(@() catstructfields(s1, s2), 'MATLAB:catstructfields:mismatchedFields');
        end

        function test_dimension_argument(testCase)
            % Test concatenation along a specified dimension
            s1 = struct('a', [1 2], 'b', [3 4]);
            s2 = struct('a', [5 6], 'b', [7 8]);

            % Test concatenation along dimension 1 (rows)
            s_cat_dim1 = catstructfields(s1, s2, 1);
            expected_a_dim1 = [1 2; 5 6];
            expected_b_dim1 = [3 4; 7 8];
            testCase.verifyEqual(s_cat_dim1.a, expected_a_dim1);
            testCase.verifyEqual(s_cat_dim1.b, expected_b_dim1);

            % Test concatenation along dimension 2 (columns)
            s_cat_dim2 = catstructfields(s1, s2, 2);
            expected_a_dim2 = [1 2 5 6];
            expected_b_dim2 = [3 4 7 8];
            testCase.verifyEqual(s_cat_dim2.a, expected_a_dim2);
            testCase.verifyEqual(s_cat_dim2.b, expected_b_dim2);
        end

        function test_empty_structs(testCase)
            % Test concatenation with empty structures
            s1 = struct('a', [], 'b', []);
            s2 = struct('a', 1, 'b', 2);
            s_cat1 = catstructfields(s1, s2);
            testCase.verifyEqual(s_cat1.a, 1);
            testCase.verifyEqual(s_cat1.b, 2);

            s_cat2 = catstructfields(s2, s1);
            testCase.verifyEqual(s_cat2.a, 1);
            testCase.verifyEqual(s_cat2.b, 2);
        end
    end
end