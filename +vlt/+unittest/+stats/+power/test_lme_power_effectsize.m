classdef test_lme_power_effectsize < matlab.unittest.TestCase
    % TEST_LME_POWER_EFFECTSIZE - Test for the LME power effect size worker function

    properties
        SampleTbl
    end

    methods (TestMethodSetup)
        function create_test_data(testCase)
            % Create a realistic sample table for a 2x2 repeated measures design
            subjects = repelem(categorical(cellstr("S" + (1:10)')), 4, 1);
            condition = repmat(categorical({'A'; 'A'; 'B'; 'B'}), 10, 1);
            day = repmat(categorical({'1'; '2'; '1'; '2'}), 10, 1);
            response = rand(40, 1) * 20 + 10;
            testCase.SampleTbl = table(subjects, condition, day, response, 'VariableNames', {'Subject', 'Condition', 'Day', 'Response'});
        end
    end

    methods (Test)

        function test_main_effect_smoketest(testCase)
            % A smoke test for a simple "main effect" analysis.
            % We use a very low target power to ensure the loop terminates quickly.
            [mdes, power_curve] = vlt.stats.power.lme_power_effectsize(...
                testCase.SampleTbl, 'Condition', 'Response', 'A', 'Subject', 'B', 0.10, ...
                'Method', 'shuffle_predictor', 'NumSimulations', 10, 'EffectStep', 5, 'ShufflePredictor', 'Condition');

            % Verifications
            testCase.verifyClass(mdes, 'double', 'MDES should be a double.');
            testCase.verifyTrue(isscalar(mdes), 'MDES should be a scalar.');
            testCase.verifyGreaterThan(mdes, 0, 'MDES should be positive.');
            testCase.verifyClass(power_curve, 'table', 'Power curve should be a table.');
            testCase.verifyEqual(power_curve.Properties.VariableNames, {'EffectSize', 'Power'}, 'Power curve table has incorrect variable names.');
            testCase.verifyGreaterThan(height(power_curve), 0, 'Power curve table should not be empty.');
        end

        function test_posthoc_effect_smoketest(testCase)
            % A smoke test for a "post-hoc" analysis using a struct-based definition.
            ref_struct = struct('Condition', 'A', 'Day', '1');
            comp_struct = struct('Condition', 'B', 'Day', '2');

            [mdes, power_curve] = vlt.stats.power.lme_power_effectsize(...
                testCase.SampleTbl, {'Condition', 'Day'}, 'Response', ref_struct, 'Subject', comp_struct, 0.10, ...
                'Method', 'shuffle_predictor', 'NumSimulations', 10, 'EffectStep', 5, 'ShufflePredictor', 'Condition');

            % Verifications
            testCase.verifyClass(mdes, 'double', 'MDES should be a double.');
            testCase.verifyTrue(isscalar(mdes), 'MDES should be a scalar.');
            testCase.verifyGreaterThan(mdes, 0, 'MDES should be positive.');
            testCase.verifyClass(power_curve, 'table', 'Power curve should be a table.');
            testCase.verifyEqual(power_curve.Properties.VariableNames, {'EffectSize', 'Power'}, 'Power curve table has incorrect variable names.');
            testCase.verifyGreaterThan(height(power_curve), 0, 'Power curve table should not be empty.');
        end

    end
end
