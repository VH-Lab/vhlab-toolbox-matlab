classdef test_trimsymbol < matlab.unittest.TestCase
% TEST_TRIMSYMBOL - tests for vlt.string.trimsymbol

	methods (Test)

		function test_documented_example(testCase)
			newstr = vlt.string.trimsymbol('*myhighlightedname#', '*#');
			testCase.verifyEqual(newstr, 'myhighlightedname');
		end

		function test_removes_internal_symbols(testCase)
			% symbols are removed everywhere, not only at the ends
			testCase.verifyEqual(vlt.string.trimsymbol('a*b*c', '*'), 'abc');
		end

		function test_no_symbols_present(testCase)
			testCase.verifyEqual(vlt.string.trimsymbol('abc', '#'), 'abc');
		end

		function test_all_removed(testCase)
			testCase.verifyTrue(isempty(vlt.string.trimsymbol('***', '*')));
		end

		function test_cell_input(testCase)
			newstr = vlt.string.trimsymbol({'*a*', '#b', 'c'}, '*#');
			testCase.verifyEqual(newstr, {'a', 'b', 'c'});
		end

	end
end
