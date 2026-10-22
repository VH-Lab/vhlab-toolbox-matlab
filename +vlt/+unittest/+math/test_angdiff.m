classdef test_angdiff < matlab.unittest.TestCase
% TEST_ANGDIFF - tests for vlt.math.angdiff

	methods (Test)

		function test_documented_examples(testCase)
			testCase.verifyEqual(vlt.math.angdiff(0-90), 90);
			testCase.verifyEqual(vlt.math.angdiff(90-0), 90);
			testCase.verifyEqual(vlt.math.angdiff(10-359), 11);
			testCase.verifyEqual(vlt.math.angdiff(10-360), 10);
		end

		function test_zero(testCase)
			testCase.verifyEqual(vlt.math.angdiff(0), 0);
		end

		function test_opposite(testCase)
			testCase.verifyEqual(vlt.math.angdiff(180), 180);
			testCase.verifyEqual(vlt.math.angdiff(-180), 180);
		end

		function test_row_vector(testCase)
			D = vlt.math.angdiff([-90 90 -349 -350 270]);
			testCase.verifyEqual(D, [90 90 11 10 90]);
		end

		function test_column_vector_values(testCase)
			% Only the values are checked here; the orientation of the
			% output for column input is not checked (the current code
			% returns a row for a column input).
			D = vlt.math.angdiff([-90; 270; 10]);
			testCase.verifyEqual(D(:), [90; 90; 10]);
		end

	end
end
