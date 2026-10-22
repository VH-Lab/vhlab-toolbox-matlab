classdef test_dangdiffwrap < matlab.unittest.TestCase
% TEST_DANGDIFFWRAP - tests for vlt.math.dangdiffwrap

	methods (Test)

		function test_row_vector_360(testCase)
			% 10: closest is 10 itself (+); -350: closest is 10 (+); 350: closest is -10 (-)
			dD = vlt.math.dangdiffwrap([10 -350 350], 360);
			testCase.verifyEqual(dD, [1 1 -1]);
		end

		function test_negative_scalar(testCase)
			testCase.verifyEqual(vlt.math.dangdiffwrap(-10, 360), -1);
		end

		function test_zero(testCase)
			testCase.verifyEqual(vlt.math.dangdiffwrap(0, 360), 0);
		end

		function test_wrap_180(testCase)
			% 100 wraps to -80 (closest to 0) so the sign is -1
			dD = vlt.math.dangdiffwrap([30 100 -100], 180);
			testCase.verifyEqual(dD, [1 -1 1]);
		end

		function test_matrix_errors(testCase)
			didError = false;
			try
				vlt.math.dangdiffwrap([1 2; 3 4], 360);
			catch
				didError = true;
			end
			testCase.verifyTrue(didError, 'Matrix input should produce an error.');
		end

	end
end
