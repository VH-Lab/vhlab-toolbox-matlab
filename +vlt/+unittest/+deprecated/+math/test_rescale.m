classdef test_rescale < matlab.unittest.TestCase
% TEST_RESCALE - tests for the deprecated function rescale (vlt/math/rescale.m)

	methods (Test)

		function test_basic_rescale(testCase)
			v = rescale([0 5 10], [0 10], [0 1]);
			testCase.verifyEqual(v, [0 0.5 1], 'AbsTol', 1e-12);
		end

		function test_offset_intervals(testCase)
			v = rescale([1 2 3], [1 3], [10 20]);
			testCase.verifyEqual(v, [10 15 20], 'AbsTol', 1e-12);
		end

		function test_clipping_default(testCase)
			v = rescale([-5 15], [0 10], [0 1]);
			testCase.verifyEqual(v, [0 1], 'AbsTol', 1e-12);
		end

		function test_noclip(testCase)
			v = rescale([-5 0 5 10 15], [0 10], [0 1], 'noclip');
			testCase.verifyEqual(v, [-0.5 0 0.5 1 1.5], 'AbsTol', 1e-12);
		end

		function test_matrix_shape_preserved(testCase)
			v = rescale([0 10; 5 20], [0 10], [0 100]);
			testCase.verifyEqual(v, [0 100; 50 100], 'AbsTol', 1e-12);
		end

	end
end
