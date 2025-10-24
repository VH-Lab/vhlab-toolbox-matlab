classdef testartificialAnovaTable < matlab.unittest.TestCase
%TESTARTIFICIALANOVATABLE Unit tests for vlt.stats.artificialAnovaTable
%
%   This test class verifies the functionality of
%   vlt.stats.artificialAnovaTable.
%
%   Tests include:
%   1.  Output table size and column names.
%   2.  Correct generation of categorical labels.
%   3.  Correct structure and content of 'powerParams' output.
%   4.  Correct application of a main effect.
%   5.  Correct application of an interaction effect.
%   6.  Correct error handling for mismatched inputs.
%
%   To run:
%   runtests('vlt.unittest.stats.testartificialAnovaTable')
%
%   See also: vlt.stats.artificialAnovaTable, matlab.unittest.TestCase

    properties
        % Define common inputs for a 2x3 design
        factorNames = {'Drug', 'Day'};
        factorLevels = [2, 3];
        nPerGroup = 10;
        differenceToTest = 5.0;
        SD_Components = struct('RandomIntercept', 2.0, 'Residual', 3.0);
    end

    methods (Test)

        function testTableStructureAndSize(testCase)
            % Test basic table structure, size, and column names.

            [T, ~] = vlt.stats.artificialAnovaTable( ...
                testCase.factorNames, ...
                testCase.factorLevels, ...
                testCase.nPerGroup, ...
                0, [], ... % No difference
                testCase.SD_Components);

            % --- 1. Test Size ---
            nDrugs = testCase.factorLevels(1);
            nDays = testCase.factorLevels(2);
            nAnimals = nDrugs * testCase.nPerGroup;
            expectedRows = nAnimals * nDays;

            testCase.assertEqual(height(T), expectedRows, ...
                'Table has incorrect number of rows.');

            % Expected columns: Drug, Day, Animal, Measurement
            testCase.assertEqual(width(T), 4, ...
                'Table has incorrect number of columns.');

            % --- 2. Test Column Names and Types ---
            testCase.assertTrue(all(ismember( ...
                {'Drug', 'Day', 'Animal', 'Measurement'}, T.Properties.VariableNames)), ...
                'Table is missing one or more required columns.');

            testCase.assertTrue(iscategorical(T.Drug), 'Drug column is not categorical.');
            testCase.assertTrue(iscategorical(T.Day), 'Day column is not categorical.');
            testCase.assertTrue(iscategorical(T.Animal), 'Animal column is not categorical.');
            testCase.assertTrue(isnumeric(T.Measurement), 'Measurement column is not numeric.');

            % --- 3. Test Factor Levels ---
            testCase.assertEqual(numel(categories(T.Drug)), nDrugs, ...
                'Incorrect number of Drug categories.');
            testCase.assertEqual(numel(categories(T.Day)), nDays, ...
                'Incorrect number of Day categories.');
            testCase.assertEqual(numel(categories(T.Animal)), nAnimals, ...
                'Incorrect number of Animal categories.');

            % Check auto-generated names
            testCase.assertTrue(ismember('Drug_1', categories(T.Drug)), ...
                'Drug_1 category was not generated.');
            testCase.assertTrue(ismember('Day_3', categories(T.Day)), ...
                'Day_3 category was not generated.');
            testCase.assertTrue(ismember(sprintf('Animal_%d', nAnimals), categories(T.Animal)), ...
                'Final Animal category was not generated.');
        end

        function testPowerParamsOutput(testCase)
            % Test that the 'powerParams' output struct is correct.

            [~, powerParams] = vlt.stats.artificialAnovaTable( ...
                testCase.factorNames, ...
                testCase.factorLevels, ...
                testCase.nPerGroup, ...
                testCase.differenceToTest, [1], ...
                testCase.SD_Components);

            kTotalGroups = prod(testCase.factorLevels); % 2*3 = 6
            expectedMSE = testCase.SD_Components.Residual^2; % 3^2 = 9

            testCase.assertEqual(powerParams.expectedDifference, testCase.differenceToTest);
            testCase.assertEqual(powerParams.expectedMSE, expectedMSE);
            testCase.assertEqual(powerParams.nPerGroup, testCase.nPerGroup);
            testCase.assertEqual(powerParams.kTotalGroups, kTotalGroups);
            testCase.assertEqual(powerParams.alpha, 0.05); % Check default
        end

        function testMainEffectApplication(testCase)
            % Test that a main effect is applied correctly by checking the
            % means of the generated data.

            % Set large N for stable means, and zero variance
            large_n = 500;
            zero_sd = struct('RandomIntercept', 0, 'Residual', 0);
            diff = 10.0;

            [T, ~] = vlt.stats.artificialAnovaTable( ...
                testCase.factorNames, ...
                testCase.factorLevels, ...
                large_n, ...
                diff, [1], ... % Main effect on Factor 1 ('Drug')
                zero_sd);

            % Find rows for 'Drug_1' (baseline) and 'Drug_2' (effect)
            idx_baseline = T.Drug == 'Drug_1';
            idx_effect = T.Drug == 'Drug_2';

            % Means should be exactly 0 and 10 (since SDs are 0)
            mean_baseline = mean(T.Measurement(idx_baseline));
            mean_effect = mean(T.Measurement(idx_effect));

            testCase.assertEqual(mean_baseline, 0, 'AbsTol', 1e-12, ...
                'Baseline group (Drug_1) mean is not 0.');
            testCase.assertEqual(mean_effect, diff, 'AbsTol', 1e-12, ...
                'Effect group (Drug_2) mean is not equal to differenceToTest.');
        end

        function testInteractionEffectApplication(testCase)
            % Test that an interaction effect is applied correctly.

            large_n = 500;
            zero_sd = struct('RandomIntercept', 0, 'Residual', 0);
            diff = 20.0;

            [T, ~] = vlt.stats.artificialAnovaTable( ...
                testCase.factorNames, ...
                testCase.factorLevels, ...
                large_n, ...
                diff, [1, 2], ... % Interaction effect on ('Drug_2', 'Day_3')
                zero_sd);

            % Find the specific cell 'Drug_2' AND 'Day_3'
            idx_effect_cell = (T.Drug == 'Drug_2' & T.Day == 'Day_3');

            % Find all other cells
            idx_baseline_cells = ~idx_effect_cell;

            mean_baseline = mean(T.Measurement(idx_baseline_cells));
            mean_effect = mean(T.Measurement(idx_effect_cell));

            testCase.assertEqual(mean_baseline, 0, 'AbsTol', 1e-12, ...
                'Baseline cells mean is not 0.');
            testCase.assertEqual(mean_effect, diff, 'AbsTol', 1e-12, ...
                'Interaction cell (Drug_2, Day_3) mean is not equal to differenceToTest.');
        end

        function testErrorHandling(testCase)
            % Test that the function errors correctly with bad inputs.
            % This test catches the standard argument validation errors
            % thrown by the custom validators in the 'arguments' block.

            % 1. Mismatched factorNames and factorLevels
            testCase.verifyError(@() ...
                vlt.stats.artificialAnovaTable( ...
                    {'Drug', 'Day', 'Time'}, [2, 3], 10, 5, [1], testCase.SD_Components), ...
                'MATLAB:InputParser:ArgumentFailedValidation', ...
                'Failed to error on mismatched factorNames/factorLevels.');

            % 2. Invalid differenceFactors index (index 3 for 2 factors)
            testCase.verifyError(@() ...
                vlt.stats.artificialAnovaTable( ...
                    testCase.factorNames, testCase.factorLevels, 10, 5, [1, 3], testCase.SD_Components), ...
                'MATLAB:InputParser:ArgumentFailedValidation', ...
                'Failed to error on invalid differenceFactors index.');

            % 3. Missing fields in SD_Components
            testCase.verifyError(@() ...
                vlt.stats.artificialAnovaTable( ...
                    testCase.factorNames, testCase.factorLevels, 10, 5, [1], struct('Foo', 1)), ...
                'MATLAB:InputParser:ArgumentFailedValidation', ...
                'Failed to error on missing SD_Components fields.');
        end

    end % methods (Test)
end % classdef
