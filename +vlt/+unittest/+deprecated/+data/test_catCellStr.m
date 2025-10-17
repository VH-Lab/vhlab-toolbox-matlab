classdef test_catCellStr < matlab.unittest.TestCase
    % TEST_CATCELLSTR - Test for the deprecated catCellStr
    %
    % Assumes that the path to the deprecated 'catCellStr.m' is on the
    % MATLAB path when the test is run.

    properties (TestParameter)
    end % properties

    methods (Test)

        function test_catCellStr_basic_deprecated(testCase)
            % Test a basic concatenation with the deprecated function
            c = {'first', 'second', 'third'};
            s = catCellStr(c);
            % note the leading space, this is the behavior of the function
            testCase.verifyEqual(s, ' first second third');
        end

        function test_catCellStr_empty_input_deprecated(testCase)
            % Test an empty cell array with the deprecated function
            c = {};
            s = catCellStr(c);
            testCase.verifyEqual(s, []);
        end

        function test_catCellStr_single_element_deprecated(testCase)
            % Test a single element cell array with the deprecated function
            c = {'single'};
            s = catCellStr(c);
            testCase.verifyEqual(s, ' single');
        end

        function test_catCellStr_with_empty_strings_deprecated(testCase)
            % Test a cell array containing empty strings with the deprecated function
            c = {'a', '', 'c'};
            s = catCellStr(c);
            testCase.verifyEqual(s, ' a  c');
        end

    end % methods
end % classdef