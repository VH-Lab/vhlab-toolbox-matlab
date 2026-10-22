classdef test_divide_nozero < matlab.unittest.TestCase
% TEST_DIVIDE_NOZERO - tests for vlt.math.divide_nozero

	methods (Test)

		function test_zero_over_zero(testCase)
			testCase.verifyEqual(vlt.math.divide_nozero(0,0), 0);
		end

		function test_ordinary_division(testCase)
			z = vlt.math.divide_nozero([1 6 -2], [2 3 4]);
			testCase.verifyEqual(z, [0.5 2 -0.5], 'AbsTol', 1e-12);
		end

		function test_nonzero_over_zero_is_inf(testCase)
			z = vlt.math.divide_nozero([1 -1], [0 0]);
			testCase.verifyEqual(z, [Inf -Inf]);
		end

		function test_mixed(testCase)
			z = vlt.math.divide_nozero([0 1 0 -2], [0 0 2 4]);
			testCase.verifyEqual(z, [0 Inf 0 -0.5]);
		end

		function test_matrix_shape(testCase)
			z = vlt.math.divide_nozero([0 2; 4 0], [0 1; 2 0]);
			testCase.verifyEqual(z, [0 2; 2 0]);
		end

	end
end
