classdef mustBeAValidTableVariable < matlab.unittest.TestCase
% VLT.UNITTEST.VALIDATORS.MUSTBEAVALIDTABLEVARIABLE Unit tests for the custom table variable validator.
%
% This test suite verifies the behavior of vlt.validators.mustBeAValidTableVariable,
% ensuring it correctly accepts valid column names and correctly throws
% errors for invalid types or non-existent column names.
    properties (TestParameter)
        % Define a simple mock table for testing
        % The framework will iterate over the fields of this struct.
        % The value (the table) will be passed to the 'TestTable' argument.
        TestTable = struct('T', table([1; 2], {'A'; 'B'}, [3; 4], 'VariableNames', {'Factor1', 'DataCol', 'Factor2'}));
    end

    methods (Test, TestTags = {'ValidInputs'})
        function testValidSingleName(testCase, TestTable)
            % Test passing a single valid column name as a string
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable('Factor1', TestTable));
        end
        function testValidMultipleNamesCell(testCase, TestTable)
            % Test passing multiple valid column names as a cell array
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable({'Factor1', 'Factor2'}, TestTable));
        end
        function testValidMultipleNamesString(testCase, TestTable)
            % Test passing multiple valid column names as a string array
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable(["Factor1", "Factor2"], TestTable));
        end
        function testValidEmptyInput_EmptyCell(testCase, TestTable)
            % Test passing an empty cell array (should be accepted as a default/optional argument)
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable({}, TestTable));
        end
        function testValidEmptyInput_EmptyString(testCase, TestTable)
            % Test passing an empty string array (the default value from the function arguments block)
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyWarningFree(@() vlt.validators.mustBeAValidTableVariable(string.empty(1,0), TestTable));
        end
    end

    methods (Test, TestTags = {'InvalidInputs', 'Failure'})
        function testInvalidName(testCase, TestTable)
            % Test passing a name that does not exist in the table
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable('NonExistentFactor', TestTable), ...
                'vlt:validators:mustBeAValidTableVariable:UnknownVariable', ...
                'Expected an error for non-existent column name.');
        end
        function testInvalidType_Numeric(testCase, TestTable)
            % Test passing a numeric array instead of a name string
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable([1 2 3], TestTable), ...
                'vlt:validators:mustBeAValidTableVariable:InvalidType', ...
                'Expected an error for numeric input type.');
        end
        function testInvalidType_Logical(testCase, TestTable)
            % Test passing a logical value instead of a name string
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable(true, TestTable), ...
                'vlt:validators:mustBeAValidTableVariable:InvalidType', ...
                'Expected an error for logical input type.');
        end
        function testInvalidType_Table(testCase, TestTable)
            % Test passing a table instead of a name string
            % FIX: Changed TestTable.T to TestTable
            testCase.verifyError(@() vlt.validators.mustBeAValidTableVariable(TestTable, TestTable), ...
                'vlt:validators:mustBeAValidTableVariable:InvalidType', ...
                'Expected an error for table input type.');
        end
    end
end
