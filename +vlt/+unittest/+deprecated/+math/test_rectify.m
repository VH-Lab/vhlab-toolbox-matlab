classdef test_rectify < matlab.unittest.TestCase
% TEST_RECTIFY - tests for the deprecated function rectify (vlt/math/rectify.m)

	methods (Test)

		function test_default_rectvalue(testCase)
			r = rectify([-2 -1 0 1 2]);
			testCase.verifyEqual(r, [0 0 0 1 2]);
		end

		function test_custom_rectvalue(testCase)
			r = rectify([-2 -1 0 1 2], -10);
			testCase.verifyEqual(r, [-10 -10 0 1 2]);
		end

		function test_nan_rectvalue(testCase)
			r = rectify([-3 4], NaN);
			testCase.verifyTrue(isnan(r(1)));
			testCase.verifyEqual(r(2), 4);
		end

		function test_matrix_shape_preserved(testCase)
			r = rectify([-1 2; 3 -4]);
			testCase.verifyEqual(r, [0 2; 3 0]);
		end

		function test_all_positive_unchanged(testCase)
			x = [0.5 1 100];
			testCase.verifyEqual(rectify(x), x);
		end

	end
end
