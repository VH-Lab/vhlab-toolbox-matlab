classdef test_stderr < matlab.unittest.TestCase
% TEST_STDERR - tests for vlt.stats.stderr

	methods (Test)

		function test_column_vector(testCase)
			data = [1;2;3;4];
			se = vlt.stats.stderr(data);
			testCase.verifyEqual(se, std(data)/sqrt(4), 'AbsTol', 1e-12);
		end

		function test_matrix_columns(testCase)
			data = [1 10; 2 20; 3 30];
			se = vlt.stats.stderr(data);
			testCase.verifyEqual(se, std(data)/sqrt(3), 'AbsTol', 1e-12);
			testCase.verifyEqual(size(se), [1 2]);
		end

		function test_constant_data(testCase)
			se = vlt.stats.stderr([5;5;5]);
			testCase.verifyEqual(se, 0, 'AbsTol', 1e-12);
		end

		function test_known_value(testCase)
			% std([2;4;4;4;5;5;7;9]) = 2.138089935..., n = 8
			data = [2;4;4;4;5;5;7;9];
			se = vlt.stats.stderr(data);
			testCase.verifyEqual(se, sqrt(32/7)/sqrt(8), 'AbsTol', 1e-12);
		end

	end
end
