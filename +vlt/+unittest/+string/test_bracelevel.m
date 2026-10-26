classdef test_bracelevel < matlab.unittest.TestCase
% TEST_BRACELEVEL - tests for vlt.string.bracelevel

	methods (Test)

		function test_documented_example(testCase)
			str = 'this is (a test of (depth))';
			level = vlt.string.bracelevel(str);
			expected = [zeros(1,9) ones(1,11) 2*ones(1,5) 1 0];
			testCase.verifyEqual(level, expected);
		end

		function test_output_size(testCase)
			str = 'a(b)c';
			level = vlt.string.bracelevel(str);
			testCase.verifyEqual(size(level), size(str));
		end

		function test_no_braces(testCase)
			testCase.verifyEqual(vlt.string.bracelevel('abc'), [0 0 0]);
		end

		function test_nested_adjacent_left(testCase)
			testCase.verifyEqual(vlt.string.bracelevel('((a))'), [0 1 2 1 0]);
		end

		function test_empty_pair(testCase)
			% an empty pair '()' should not change the depth
			testCase.verifyEqual(vlt.string.bracelevel('f()'), [0 0 0]);
			testCase.verifyEqual(vlt.string.bracelevel('f()g(x)'), [0 0 0 0 0 1 0]);
		end

		function test_trailing_left_brace(testCase)
			% a left brace at the end must not lengthen the output
			level = vlt.string.bracelevel('abc(');
			testCase.verifyEqual(level, [0 0 0 0]);
		end

		function test_empty_string(testCase)
			testCase.verifyTrue(isempty(vlt.string.bracelevel('')));
		end

		function test_custom_braces(testCase)
			str2 = 'this is [a test of [depth]]';
			level = vlt.string.bracelevel(str2, '[', ']');
			expected = [zeros(1,9) ones(1,11) 2*ones(1,5) 1 0];
			testCase.verifyEqual(level, expected);
		end

		function test_custom_braces_ignore_parens(testCase)
			level = vlt.string.bracelevel('(a)', '[', ']');
			testCase.verifyEqual(level, [0 0 0]);
		end

	end
end
