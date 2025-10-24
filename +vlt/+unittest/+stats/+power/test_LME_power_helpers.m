classdef test_LME_power_helpers < matlab.unittest.TestCase
    % TEST_LME_POWER_HELPERS - Tests for the LME simulation helper functions

    properties
        SampleTbl
        LmeBase
        TblBase
        EffectSize = 5;
        CategoryName = 'Model_Year';
        CategoryLevel = '76';
        YName = 'MPG';
        YNameFixed = 'MPG';
        GroupName = 'Mfg';
    end

    methods (TestMethodSetup)
        function setup_data(testCase)
            % Create a sample table and baseline LME model for testing
            Mfg = categorical(repmat({'A'; 'B'; 'C'; 'D'}, 5, 1));
            Model_Year = categorical(repmat({'70'; '76'; '82'; '85'; '90'}, 4, 1));
            MPG = rand(20, 1) * 20 + 10;
            testCase.SampleTbl = table(Mfg, Model_Year, MPG);

            [testCase.LmeBase, testCase.TblBase] = vlt.stats.lme_category(...
                testCase.SampleTbl, testCase.CategoryName, testCase.YName, 'Y', '70', testCase.GroupName, 0, 0);
        end
    end

    methods (Test)
        function test_simulate_lme_data_gaussian(testCase)
            % Test the 'gaussian' simulation method
            simTbl = vlt.stats.power.simulate_lme_data(testCase.LmeBase, testCase.TblBase, ...
                testCase.EffectSize, testCase.CategoryName, testCase.CategoryLevel, testCase.YNameFixed, testCase.GroupName);

            % Verifications
            testCase.verifyClass(simTbl, 'table', 'Output should be a table.');
            testCase.verifyEqual(height(simTbl), height(testCase.TblBase), 'Output table should have the same number of rows.');
            testCase.verifyNotEqual(simTbl.(testCase.YNameFixed), testCase.TblBase.(testCase.YNameFixed), ...
                'Simulated Y values should not be identical to the original.');
        end

        function test_simulate_lme_data_shuffled(testCase)
            % Test the 'shuffle' simulation method
            simTbl = vlt.stats.power.simulate_lme_data_shuffled(testCase.LmeBase, testCase.TblBase, ...
                testCase.EffectSize, testCase.CategoryName, testCase.CategoryLevel, testCase.YNameFixed, testCase.GroupName);

            % Verifications
            testCase.verifyClass(simTbl, 'table', 'Output should be a table.');
            testCase.verifyEqual(height(simTbl), height(testCase.TblBase), 'Output table should have the same number of rows.');
            testCase.verifyNotEqual(simTbl.(testCase.YNameFixed), testCase.TblBase.(testCase.YNameFixed), ...
                'Simulated Y values should not be identical to the original.');
        end

        function test_simulate_lme_data_hierarchical(testCase)
            % Test the 'hierarchical' simulation method
            simTbl = vlt.stats.power.simulate_lme_data_hierarchical(testCase.LmeBase, testCase.TblBase, ...
                testCase.EffectSize, testCase.CategoryName, testCase.CategoryLevel, testCase.YNameFixed, testCase.GroupName);

            % Verifications
            testCase.verifyClass(simTbl, 'table', 'Output should be a table.');
            testCase.verifyEqual(height(simTbl), height(testCase.TblBase), 'Output table should have the same number of rows.');
            testCase.verifyNotEqual(simTbl.(testCase.YNameFixed), testCase.TblBase.(testCase.YNameFixed), ...
                'Simulated Y values should not be identical to the original.');
        end
    end
end
