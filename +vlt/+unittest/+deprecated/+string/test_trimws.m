classdef test_trimws < matlab.unittest.TestCase
% TEST_TRIMWS - tests for the deprecated function trimws (vlt/string/trimws.m)

	methods (Test)

		function test_leading_spaces(testCase)
			s = trimws('   this string has leading whitespace');
			testCase.verifyEqual(s, 'this string has leading whitespace');
		end

		function test_trailing_spaces_kept(testCase)
			s = trimws('  abc  ');
			testCase.verifyEqual(s, 'abc  ');
		end

		function test_no_spaces(testCase)
			testCase.verifyEqual(trimws('abc'), 'abc');
		end

		function test_internal_spaces_kept(testCase)
			testCase.verifyEqual(trimws(' a b c'), 'a b c');
		end

		function test_only_spaces_removed_not_tabs(testCase)
			% only the space character is trimmed, not other whitespace
			s = trimws([' ' char(9) 'abc']);
			testCase.verifyEqual(s, [char(9) 'abc']);
		end

		function test_empty(testCase)
			testCase.verifyTrue(isempty(trimws('')));
		end

	end
end
