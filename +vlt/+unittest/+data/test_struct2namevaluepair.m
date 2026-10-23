classdef test_struct2namevaluepair < matlab.unittest.TestCase
% TEST_STRUCT2NAMEVALUEPAIR - tests for vlt.data.struct2namevaluepair

	methods (Test)

		function test_documented_example(testCase)
			myStruct.param1 = 1;
			myStruct.param2 = 2;
			nv = vlt.data.struct2namevaluepair(myStruct);
			testCase.verifyEqual(nv, {'param1', 1, 'param2', 2});
		end

		function test_mixed_value_types(testCase)
			s = struct('name', 'abc', 'vec', [1 2 3]);
			s.c = {4};
			nv = vlt.data.struct2namevaluepair(s);
			testCase.verifyEqual(nv, {'name', 'abc', 'vec', [1 2 3], 'c', {4}});
		end

		function test_empty_struct(testCase)
			nv = vlt.data.struct2namevaluepair(struct([]));
			testCase.verifyTrue(iscell(nv));
			testCase.verifyTrue(isempty(nv));
		end

		function test_struct_no_fields(testCase)
			nv = vlt.data.struct2namevaluepair(struct());
			testCase.verifyTrue(iscell(nv));
			testCase.verifyTrue(isempty(nv));
		end

		function test_round_trip_with_cell2struct(testCase)
			s = struct('x', 10, 'y', 'yes');
			nv = vlt.data.struct2namevaluepair(s);
			s2 = cell2struct(nv(2:2:end), nv(1:2:end), 2);
			testCase.verifyEqual(s2, s);
		end

	end
end
