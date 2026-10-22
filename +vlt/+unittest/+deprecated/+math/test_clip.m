classdef test_clip < matlab.unittest.TestCase
% TEST_CLIP - tests for the deprecated function clip (vlt/math/clip.m)

	methods (Test)

		function test_documented_example(testCase)
			b = clip([-Inf 0 1 2 3 Inf],[1 2]);
			testCase.verifyEqual(b, [1 1 1 2 2 2]);
		end

		function test_values_inside_unchanged(testCase)
			a = [1.1 1.5 1.9];
			b = clip(a,[1 2]);
			testCase.verifyEqual(b, a);
		end

		function test_matrix_shape_preserved(testCase)
			a = [-5 0 5; 10 2 -1];
			b = clip(a,[0 5]);
			testCase.verifyEqual(b, [0 0 5; 5 2 0]);
		end

		function test_column_shape_preserved(testCase)
			b = clip([-1;0.5;3],[0 1]);
			testCase.verifyEqual(b, [0;0.5;1]);
		end

		function test_empty_input(testCase)
			b = clip([],[0 1]);
			testCase.verifyTrue(isempty(b));
		end

	end
end
