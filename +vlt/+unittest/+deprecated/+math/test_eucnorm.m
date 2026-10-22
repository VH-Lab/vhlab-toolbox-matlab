classdef test_eucnorm < matlab.unittest.TestCase
% TEST_EUCNORM - tests for the deprecated function eucnorm (vlt/math/eucnorm.m)

	methods (Test)

		function test_column_vector(testCase)
			testCase.verifyEqual(eucnorm([3;4]), 5, 'AbsTol', 1e-12);
		end

		function test_matrix_columns(testCase)
			d = eucnorm([3 1 0; 4 0 2]);
			testCase.verifyEqual(d, [5 1 2], 'AbsTol', 1e-12);
		end

		function test_row_vector_is_per_column(testCase)
			% each column of a row vector is a single element
			d = eucnorm([-3 4]);
			testCase.verifyEqual(d, [3 4], 'AbsTol', 1e-12);
		end

		function test_matches_norm(testCase)
			x = [1;2;3;4];
			testCase.verifyEqual(eucnorm(x), norm(x), 'AbsTol', 1e-12);
		end

	end
end
