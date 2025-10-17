classdef test_catCellStr < matlab.unittest.TestCase
    % TEST_CATCELLSTR - Test for vlt.data.catCellStr
    %
    %

    properties (TestParameter)
    end % properties

    methods (Test)

        function test_catCellStr_basic(testCase)
            % Test a basic concatenation
            c = {'first', 'second', 'third'};
            s = vlt.data.catCellStr(c);
            % note the leading space, this is the behavior of the function
            testCase.verifyEqual(s, ' first second third');
        end

        function test_catCellStr_empty_input(testCase)
            % Test an empty cell array
            c = {};
            s = vlt.data.catCellStr(c);
            testCase.verifyEqual(s, []);
        end

        function test_catCellStr_single_element(testCase)
            % Test a single element cell array
            c = {'single'};
            s = vlt.data.catCellStr(c);
            testCase.verifyEqual(s, ' single');
        end

        function test_catCellStr_with_empty_strings(testCase)
            % Test a cell array containing empty strings
            c = {'a', '', 'c'};
            s = vlt.data.catCellStr(c);
            testCase.verifyEqual(s, ' a  c');
        end

    end % methods
end % classdef