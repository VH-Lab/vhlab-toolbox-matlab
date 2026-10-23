classdef test_center_of_mass < matlab.unittest.TestCase
% TEST_CENTER_OF_MASS - tests for the deprecated function center_of_mass (vlt/math/center_of_mass.m)

	methods (Test)

		function test_unweighted_2d(testCase)
			pts = [0 0; 2 0; 2 2; 0 2];
			pos = center_of_mass(pts);
			testCase.verifyEqual(pos, [1 1], 'AbsTol', 1e-12);
		end

		function test_weighted_2d(testCase)
			pts = [0 0; 4 0];
			pos = center_of_mass(pts, [3 1]);
			testCase.verifyEqual(pos, [1 0], 'AbsTol', 1e-12);
		end

		function test_weights_as_column(testCase)
			pts = [0 0; 4 0];
			pos = center_of_mass(pts, [3;1]);
			testCase.verifyEqual(pos, [1 0], 'AbsTol', 1e-12);
		end

		function test_3d(testCase)
			pts = [1 2 3; 3 4 5];
			pos = center_of_mass(pts);
			testCase.verifyEqual(pos, [2 3 4], 'AbsTol', 1e-12);
		end

		function test_single_point(testCase)
			pos = center_of_mass([5 7]);
			testCase.verifyEqual(pos, [5 7], 'AbsTol', 1e-12);
		end

		function test_1d_points(testCase)
			pos = center_of_mass([1;2;3;6]);
			testCase.verifyEqual(pos, 3, 'AbsTol', 1e-12);
		end

	end
end
