classdef test_structmerge < matlab.unittest.TestCase
% TEST_STRUCTMERGE - tests for the deprecated function structmerge (vlt/datastructures/structmerge.m)

	methods (Test)

		function test_merge_with_overlap(testCase)
			s1 = struct('a', 1, 'c', 3);
			s2 = struct('b', 2, 'c', 30);
			s = structmerge(s1, s2);
			testCase.verifyEqual(s.a, 1);
			testCase.verifyEqual(s.b, 2);
			testCase.verifyEqual(s.c, 30, 'Values of S2 should take precedence.');
		end

		function test_alphabetical_order_default(testCase)
			s1 = struct('z', 1, 'a', 2);
			s2 = struct('m', 3);
			s = structmerge(s1, s2);
			testCase.verifyEqual(fieldnames(s), {'a';'m';'z'});
		end

		function test_no_alphabetical(testCase)
			s1 = struct('z', 1, 'a', 2);
			s2 = struct('m', 3);
			s = structmerge(s1, s2, 'DoAlphabetical', 0);
			testCase.verifyEqual(fieldnames(s), {'z';'a';'m'});
			testCase.verifyEqual(s.m, 3);
		end

		function test_error_if_new_field(testCase)
			s1 = struct('a', 1);
			s2 = struct('b', 2);
			didError = false;
			try
				structmerge(s1, s2, 'ErrorIfNewField', 1);
			catch
				didError = true;
			end
			testCase.verifyTrue(didError, 'A new field in S2 should produce an error.');
		end

		function test_error_if_new_field_no_new_fields(testCase)
			s1 = struct('a', 1, 'b', 2);
			s2 = struct('b', 20);
			s = structmerge(s1, s2, 'ErrorIfNewField', 1);
			testCase.verifyEqual(s.a, 1);
			testCase.verifyEqual(s.b, 20);
		end

		function test_cell_and_struct_values(testCase)
			s1 = struct('a', {{1, 'two'}});
			s2 = struct('b', struct('inner', 5));
			s = structmerge(s1, s2);
			testCase.verifyEqual(s.a, {1, 'two'});
			testCase.verifyEqual(s.b.inner, 5);
		end

	end
end
