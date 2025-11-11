classdef testAddDifference < matlab.unittest.TestCase
    % TESTADDDIFFERENCE - Test class for the vlt.table.addDifference function.
    %
    %   This class contains unit tests for the vlt.table.addDifference function,
    %   which is used to add a numeric difference to a specific subset of a
    %   MATLAB table. The tests cover single-factor targeting (using strings)
    %   and multi-factor targeting (using structs).
    %
    %   See also: vlt.table.addDifference
    %

    properties
        SampleTable
    end

    methods(TestMethodSetup)
        function createSampleTable(testCase)
            % Creates a consistent sample table before each test method runs.
            testCase.SampleTable = table( ...
                categorical({'A';'A';'B';'B';'A'}), ...
                categorical({'X';'Y';'X';'Y';'X'}), ...
                [10; 12; 20; 22; 15], ...
                'VariableNames', {'Condition', 'Group', 'Measurement'});
        end
    end

    methods(Test)
        function testSingleFactorTargeting(testCase)
            % Tests adding a difference to a group defined by a single factor.

            % Target all rows where 'Condition' is 'B'
            modifiedTable = vlt.table.addDifference(testCase.SampleTable, 'Measurement', 'B', 5);

            expected = [10; 12; 25; 27; 15]; % Rows 3 and 4 should be incremented
            testCase.verifyEqual(modifiedTable.Measurement, expected, ...
                'Single-factor targeting did not produce the expected result.');
        end

        function testMultiFactorTargeting(testCase)
            % Tests adding a difference to a group defined by multiple factors using a struct.

            % Define a target group where Condition is 'A' AND Group is 'X'
            target = struct('Condition', 'A', 'Group', 'X');
            modifiedTable = vlt.table.addDifference(testCase.SampleTable, 'Measurement', target, 100);

            % Rows 1 and 5 should be incremented (10->110, 15->115)
            expected = [110; 12; 20; 22; 115];
            testCase.verifyEqual(modifiedTable.Measurement, expected, ...
                'Multi-factor targeting did not produce the expected result.');
        end

        function testNoMatchingRows(testCase)
            % Tests that the function does nothing when the target group does not exist.

            target = struct('Condition', 'C'); % 'C' does not exist
            modifiedTable = vlt.table.addDifference(testCase.SampleTable, 'Measurement', target, 1000);

            % The table should be unchanged
            testCase.verifyEqual(modifiedTable.Measurement, testCase.SampleTable.Measurement, ...
                'Table was modified even when no rows matched the target group.');
        end

        function testErrorHandling(testCase)
            % Tests that the function errors correctly for invalid inputs.

            % 1. Test with a non-existent data column
            testCase.verifyError(@() vlt.table.addDifference(testCase.SampleTable, 'BadColumn', 'A', 5), ...
                'vlt:validators:mustBeAValidTableVariable:notFound', ...
                'Did not error for a non-existent data column.');

            % 2. Test with a non-existent factor column in the struct
            target = struct('BadFactor', 'A');
            testCase.verifyError(@() vlt.table.addDifference(testCase.SampleTable, 'Measurement', target, 5), ...
                'MATLAB:table:UnrecognizedVarName', ...
                'Did not error for a non-existent factor column in the target struct.');
        end

    end
end
