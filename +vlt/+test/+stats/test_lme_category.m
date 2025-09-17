classdef test_lme_category < matlab.unittest.TestCase
    % TEST_LME_CATEGORY - Test for the lme_category function
    %

    properties
    end

    methods (Test)
        function test_smoke(testCase)
            % TEST_SMOKE - A simple smoke test for lme_category

            % Create a sample table
            Mfg = repmat({'A'; 'B'; 'C'}, 4, 1);
            Model_Year = repmat({'70'; '76'; '82'}, 4, 1);
            MPG = rand(12, 1) * 10 + 20; % Random MPG values
            tbl = table(Mfg, Model_Year, MPG);

            % Define parameters
            categories_name = 'Model_Year';
            y_name = 'MPG';
            y_op = 'Y';
            reference_category = '70';
            group_name = 'Mfg';
            rankorder = 0;
            logdata = 0;

            % Call the function
            [lme, newtable] = vlt.stats.lme_category(tbl, categories_name, y_name, y_op, reference_category, group_name, rankorder, logdata);

            % Verifications
            testCase.verifyClass(lme, 'LinearMixedModel', 'The output should be a LinearMixedModel object.');
            testCase.verifyEqual(height(newtable), height(tbl), 'The new table should have the same number of rows as the input table.');
            testCase.verifyTrue(any(strcmp(newtable.Properties.VariableNames, 'original_data')), 'The new table should contain the original_data column.');
        end
    end
end
