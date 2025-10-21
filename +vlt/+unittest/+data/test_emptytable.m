classdef test_emptytable < matlab.unittest.TestCase
    % TEST_EMPTYTABLE - test the vlt.data.emptytable function

    methods (Test)

        function test_simple_creation(testCase)
            % tests creation of a simple table

            names = {"id","a","b"};
            types = {"string","double","uint8"};

            t = vlt.data.emptytable(names{1},types{1},names{2},types{2},names{3},types{3});

            testCase.verifyEqual(size(t),[0 3]);
            testCase.verifyEqual(t.Properties.VariableNames, cellstr(names));

            % need to check variable types
            varTypes = t.Properties.VariableTypes;
            testCase.verifyEqual(varTypes, cellstr(types')); % Note: MATLAB returns this as a column
		end

		function test_empty_call(testCase)
			% test calling with no arguments
			t = vlt.data.emptytable();
			testCase.verifyEqual(size(t),[0 0]);
		end

    end

end
