classdef test_bracematch < matlab.unittest.TestCase
% TEST_BRACEMATCH - tests for the deprecated function bracematch (vlt/string/bracematch.m)

	methods (Test)

		function test_documented_example(testCase)
			str = 'this is (a test of (depth))';
			testCase.verifyEqual(bracematch(str, 9), 27);
			testCase.verifyEqual(bracematch(str, 20), 26);
		end

		function test_simple(testCase)
			testCase.verifyEqual(bracematch('f(x)+g(y)', 2), 4);
			testCase.verifyEqual(bracematch('f(x)+g(y)', 7), 9);
		end

		function test_custom_braces(testCase)
			str = 'a [b [c]]';
			m1 = bracematch(str, 3, 'braceleft', '[', 'braceright', ']');
			m2 = bracematch(str, 6, 'braceleft', '[', 'braceright', ']');
			testCase.verifyEqual(m1, 9);
			testCase.verifyEqual(m2, 8);
		end

		function test_precomputed_bracedepth(testCase)
			str = 'this is (a test of (depth))';
			bd = bracelevel(str);
			testCase.verifyEqual(bracematch(str, 20, 'bracedepth', bd), 26);
		end

		function test_second_output_is_bracedepth(testCase)
			str = 'this is (a test of (depth))';
			[m, bd] = bracematch(str, 9);
			testCase.verifyEqual(m, 27);
			testCase.verifyEqual(bd, bracelevel(str));
		end

		function test_empty_pair(testCase)
			testCase.verifyEqual(bracematch('f()', 2), 3);
			testCase.verifyEqual(bracematch('f()+(g)', 5), 7);
		end

		function test_unmatched_returns_empty(testCase)
			testCase.verifyTrue(isempty(bracematch('a(b', 2)));
		end

	end
end
