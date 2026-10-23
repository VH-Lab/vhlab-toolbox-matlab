classdef test_bracelevel < matlab.unittest.TestCase
% TEST_BRACELEVEL - tests for the deprecated function bracelevel (vlt/string/bracelevel.m)

	methods (Test)

		function test_documented_example(testCase)
			str = 'this is (a test of (depth))';
			level = bracelevel(str);
			expected = [zeros(1,9) ones(1,11) 2*ones(1,5) 1 0];
			testCase.verifyEqual(level, expected);
		end

		function test_output_size(testCase)
			str = 'a(b)c';
			level = bracelevel(str);
			testCase.verifyEqual(size(level), size(str));
		end

		function test_no_braces(testCase)
			testCase.verifyEqual(bracelevel('abc'), [0 0 0]);
		end

		function test_nested_adjacent_left(testCase)
			testCase.verifyEqual(bracelevel('((a))'), [0 1 2 1 0]);
		end

		function test_custom_braces(testCase)
			str2 = 'this is [a test of [depth]]';
			level = bracelevel(str2, '[', ']');
			expected = [zeros(1,9) ones(1,11) 2*ones(1,5) 1 0];
			testCase.verifyEqual(level, expected);
		end

		function test_custom_braces_ignore_parens(testCase)
			level = bracelevel('(a)', '[', ']');
			testCase.verifyEqual(level, [0 0 0]);
		end

	end
end
