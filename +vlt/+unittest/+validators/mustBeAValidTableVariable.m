classdef mustBeAValidTableVariable < matlab.unittest.TestCase
% VLT.UNITTEST.VALIDATORS.MUSTBEAVALIDTABLEVARIABLE Unit tests for the custom table variable validator.
%
% This test suite verifies the behavior of vlt.validators.mustBeAValidTableVariable,
% ensuring it correctly accepts valid column names and correctly throws
% errors for invalid types or non-existent column names.

    properties (TestParameter)
        % Define a simple mock table for testing
        TestTable = struct('T', table([1; 2], {'A'; 'B'}, 3:4, 'VariableNames', {'Factor1', 'DataCol', 'Factor2'}));
    end

    methods (Test, TestTags = {'ValidInputs'})
        function testValidSingleName(testCase, TestTable)
            % Test passing a single valid column name as a string
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable('Factor1', TestTable.T));
        end

        function testValidMultipleNamesCell(testCase, TestTable)
            % Test passing multiple valid column names as a cell array
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable({'Factor1', 'Factor2'}, TestTable.T));
        end

        function testValidMultipleNamesString(testCase, TestTable)
            % Test passing multiple valid column names as a string array
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable(["Factor1", "Factor2"], TestTable.T));
        end

        function testValidEmptyInput_EmptyCell(testCase, TestTable)
            % Test passing an empty cell array (should be accepted as a default/optional argument)
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable({}, TestTable.T));
        end

        function testValidEmptyInput_EmptyString(testCase, TestTable)
            % Test passing an empty string array (the default value from the function arguments block)
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable(string.empty(1,0), TestTable.T));
        end
    end

    methods (Test, TestTags = {'InvalidInputs', 'Failure'})
        function testInvalidName(testCase, TestTable)
            % Test passing a name that does not exist in the table
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable('NonExistentFactor', TestTable.T), ...
                'vlt:table:shuffle:UnknownVariable', ...
                'Expected an error for non-existent column name.');
        end

        function testInvalidType_Numeric(testCase, TestTable)
            % Test passing a numeric array instead of a name string
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable([1 2 3], TestTable.T), ...
                'vlt:table:shuffle:InvalidType', ...
                'Expected an error for numeric input type.');
        end

        function testInvalidType_Logical(testCase, TestTable)
            % Test passing a logical value instead of a name string
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable(true, TestTable.T), ...
                'vlt:table:shuffle:InvalidType', ...
                'Expected an error for logical input type.');
        end

        function testInvalidType_Table(testCase, TestTable)
            % Test passing a table instead of a name string
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable(TestTable.T, TestTable.T), ...
                'vlt:table:shuffle:InvalidType', ...
                'Expected an error for table input type.');
        end
    end

end
