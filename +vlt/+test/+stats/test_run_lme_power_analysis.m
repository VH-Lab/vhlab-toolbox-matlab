classdef test_run_lme_power_analysis < matlab.unittest.TestCase
    % TEST_RUN_LME_POWER_ANALYSIS - Test for the main power analysis pipeline

    properties
        SampleTbl
    end

    methods (TestMethodSetup)
        function create_test_data(testCase)
            % Create a sample table for testing
            Mfg = categorical(repmat({'A'; 'B'; 'C'; 'D'}, 10, 1));
            Model_Year = categorical(repmat({'70'; '76'; '82'; '85'}, 10, 1));
            MPG = rand(40, 1) * 20 + 10;
            testCase.SampleTbl = table(Mfg, Model_Year, MPG);
        end
    end

    methods (Test)

        function test_pipeline_execution_gaussian(testCase)
            % Test the full pipeline with the 'gaussian' method

            [mdes, power_curve] = vlt.stats.run_lme_power_analysis(...
                testCase.SampleTbl, 'Model_Year', 'MPG', '70', 'Mfg', '76', 0.80, ...
                'Method', 'gaussian', 'NumSimulations', 10, 'EffectStep', 5); % Low sims for speed

            % Verifications
            testCase.verifyClass(mdes, 'double', 'MDES should be a double.');
            testCase.verifyTrue(isscalar(mdes), 'MDES should be a scalar.');
            testCase.verifyGreaterThan(mdes, 0, 'MDES should be positive.');

            testCase.verifyClass(power_curve, 'table', 'Power curve should be a table.');
            testCase.verifyEqual(power_curve.Properties.VariableNames, {'EffectSize', 'Power'}, ...
                'Power curve table has incorrect variable names.');
            testCase.verifyGreaterThan(height(power_curve), 0, 'Power curve table should not be empty.');
        end

        function test_pipeline_execution_hierarchical(testCase)
            % Test the full pipeline with the 'hierarchical' method

            [mdes, power_curve] = vlt.stats.run_lme_power_analysis(...
                testCase.SampleTbl, 'Model_Year', 'MPG', '70', 'Mfg', '76', 0.80, ...
                'Method', 'hierarchical', 'NumSimulations', 10, 'EffectStep', 5); % Low sims for speed

            % Verifications
            testCase.verifyClass(mdes, 'double', 'MDES should be a double.');
            testCase.verifyTrue(isscalar(mdes), 'MDES should be a scalar.');
            testCase.verifyGreaterThan(mdes, 0, 'MDES should be positive.');

            testCase.verifyClass(power_curve, 'table', 'Power curve should be a table.');
            testCase.verifyEqual(power_curve.Properties.VariableNames, {'EffectSize', 'Power'}, ...
                'Power curve table has incorrect variable names.');
            testCase.verifyGreaterThan(height(power_curve), 0, 'Power curve table should not be empty.');
        end

    end
end
