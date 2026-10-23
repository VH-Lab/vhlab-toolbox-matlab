classdef test_intseq2str < matlab.unittest.TestCase
% TEST_INTSEQ2STR - tests for the deprecated function intseq2str (vlt/string/intseq2str.m)

	methods (Test)

		function test_documented_example(testCase)
			testCase.verifyEqual(intseq2str([1 2 3 7 10]), '1-3,7,10');
		end

		function test_single_run(testCase)
			testCase.verifyEqual(intseq2str([4 5 6 7]), '4-7');
		end

		function test_column_input(testCase)
			testCase.verifyEqual(intseq2str([1;2;3;7;10]), '1-3,7,10');
		end

		function test_single_value(testCase)
			testCase.verifyEqual(intseq2str(5), '5');
		end

		function test_no_runs(testCase)
			testCase.verifyEqual(intseq2str([1 3 5]), '1,3,5');
		end

		function test_two_runs(testCase)
			testCase.verifyEqual(intseq2str([1 2 5 6]), '1-2,5-6');
		end

		function test_single_then_run(testCase)
			testCase.verifyEqual(intseq2str([1 3 4 5]), '1,3-5');
		end

		function test_custom_separators(testCase)
			str = intseq2str([1 2 3 7 10], 'sep', ';', 'seq', ':');
			testCase.verifyEqual(str, '1:3;7;10');
		end

		function test_custom_separators_round_trip(testCase)
			A = [-3 -2 -1 4 6 7];
			str = intseq2str(A, 'sep', ';', 'seq', ':');
			testCase.verifyEqual(str, '-3:-1;4;6:7');
			testCase.verifyEqual(str2intseq(str, 'sep', ';', 'seq', ':'), A);
		end

		function test_empty(testCase)
			testCase.verifyTrue(isempty(intseq2str([])));
		end

		function test_round_trip_with_str2intseq(testCase)
			A = [1 2 3 7 10 11 12 20];
			testCase.verifyEqual(str2intseq(intseq2str(A)), A);
		end

	end
end
