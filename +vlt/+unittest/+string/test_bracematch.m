classdef test_bracematch < matlab.unittest.TestCase
% TEST_BRACEMATCH - tests for vlt.string.bracematch

	methods (Test)

		function test_documented_example(testCase)
			str = 'this is (a test of (depth))';
			testCase.verifyEqual(vlt.string.bracematch(str, 9), 27);
			testCase.verifyEqual(vlt.string.bracematch(str, 20), 26);
		end

		function test_simple(testCase)
			testCase.verifyEqual(vlt.string.bracematch('f(x)+g(y)', 2), 4);
			testCase.verifyEqual(vlt.string.bracematch('f(x)+g(y)', 7), 9);
		end

		function test_custom_braces(testCase)
			str = 'a [b [c]]';
			m1 = vlt.string.bracematch(str, 3, 'braceleft', '[', 'braceright', ']');
			m2 = vlt.string.bracematch(str, 6, 'braceleft', '[', 'braceright', ']');
			testCase.verifyEqual(m1, 9);
			testCase.verifyEqual(m2, 8);
		end

		function test_precomputed_bracedepth(testCase)
			str = 'this is (a test of (depth))';
			bd = vlt.string.bracelevel(str);
			testCase.verifyEqual(vlt.string.bracematch(str, 20, 'bracedepth', bd), 26);
		end

		function test_unmatched_returns_empty(testCase)
			testCase.verifyTrue(isempty(vlt.string.bracematch('a(b', 2)));
		end

	end
end
