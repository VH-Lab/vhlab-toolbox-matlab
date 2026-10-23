classdef test_str2intseq < matlab.unittest.TestCase
% TEST_STR2INTSEQ - tests for vlt.string.str2intseq

	methods (Test)

		function test_documented_example(testCase)
			a = vlt.string.str2intseq('1-3,7,10,12');
			testCase.verifyEqual(a, [1 2 3 7 10 12]);
		end

		function test_single_value(testCase)
			testCase.verifyEqual(vlt.string.str2intseq('5'), 5);
		end

		function test_single_run(testCase)
			testCase.verifyEqual(vlt.string.str2intseq('4-7'), [4 5 6 7]);
		end

		function test_whitespace_ignored(testCase)
			a = vlt.string.str2intseq(' 1 - 3 , 7 ');
			testCase.verifyEqual(a, [1 2 3 7]);
		end

		function test_custom_separators(testCase)
			a = vlt.string.str2intseq('1:3;8', 'sep', ';', 'seq', ':');
			testCase.verifyEqual(a, [1 2 3 8]);
		end

		function test_empty(testCase)
			testCase.verifyTrue(isempty(vlt.string.str2intseq('')));
		end

	end
end
