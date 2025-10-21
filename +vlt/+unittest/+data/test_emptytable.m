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
            testCase.verifyEqual(varTypes, types);
		end

		function test_empty_call_error(testCase)
			% test calling with no arguments throws an error as expected
			testCase.verifyError(@() vlt.data.emptytable(), 'MATLAB:table:InvalidVarNames');
		end

    end

end
