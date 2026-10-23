classdef test_trimws < matlab.unittest.TestCase
% TEST_TRIMWS - tests for vlt.string.trimws

	methods (Test)

		function test_leading_spaces(testCase)
			s = vlt.string.trimws('   this string has leading whitespace');
			testCase.verifyEqual(s, 'this string has leading whitespace');
		end

		function test_trailing_spaces_kept(testCase)
			s = vlt.string.trimws('  abc  ');
			testCase.verifyEqual(s, 'abc  ');
		end

		function test_no_spaces(testCase)
			testCase.verifyEqual(vlt.string.trimws('abc'), 'abc');
		end

		function test_internal_spaces_kept(testCase)
			testCase.verifyEqual(vlt.string.trimws(' a b c'), 'a b c');
		end

		function test_only_spaces_removed_not_tabs(testCase)
			% only the space character is trimmed, not other whitespace
			s = vlt.string.trimws([' ' char(9) 'abc']);
			testCase.verifyEqual(s, [char(9) 'abc']);
		end

		function test_all_spaces(testCase)
			s = vlt.string.trimws('    ');
			testCase.verifyTrue(isempty(s));
			testCase.verifyTrue(ischar(s));
		end

		function test_empty(testCase)
			testCase.verifyTrue(isempty(vlt.string.trimws('')));
		end

	end
end
