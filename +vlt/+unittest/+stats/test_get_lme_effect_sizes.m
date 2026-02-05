classdef test_get_lme_effect_sizes < matlab.unittest.TestCase
    % TEST_GET_LME_EFFECT_SIZES Unit test for vlt.stats.get_lme_effect_sizes
    %
    %   Usage:
    %       result = run(test_get_lme_effect_sizes);
    %
    %   This test suite verifies:
    %   1. That the function runs correctly on a standard model without interactions.
    %   2. That the math (Cohen's d, StdBeta, and N) matches manual calculations.
    %   3. That the function correctly throws an error when interactions are present.

    properties
        TestTable
        SimpleLME
        InteractionLME
    end

    methods (TestMethodSetup)
        function createSyntheticData(testCase)
            % Create reproducible synthetic data for testing
            rng(123); % Set seed for reproducibility
            
            numRows = 100;
            
            % Predictors
            % x_cont: Continuous variable
            x_cont = randn(numRows, 1); 
            
            % x_cat: Categorical variable (0 or 1)
            x_cat = double(rand(numRows, 1) > 0.5); 
            
            % Random Effect grouping (Subjects 1-10)
            subjects = repmat((1:10)', 10, 1);
            
            % Response variable (y)
            % Model: y = 2*x_cont + 3*x_cat + noise + random_intercept
            noise = randn(numRows, 1) * 0.5;
            subject_offsets = randn(10, 1);
            y = 2*x_cont + 3*x_cat + noise + subject_offsets(subjects);
            
            % Create Table
            testCase.TestTable = table(y, x_cont, x_cat, subjects, ...
                'VariableNames', {'Response', 'PredictorCont', 'PredictorCat', 'Subject'});
            
            % Fit Simple Model (No interactions)
            testCase.SimpleLME = fitlme(testCase.TestTable, ...
                'Response ~ PredictorCont + PredictorCat + (1|Subject)');
            
            % Fit Interaction Model (For error testing)
            testCase.InteractionLME = fitlme(testCase.TestTable, ...
                'Response ~ PredictorCont * PredictorCat + (1|Subject)');
        end
    end

    methods (Test)
        
        function testStructureFields(testCase)
            % Verify the output structure has the correct field names
            es = vlt.stats.get_lme_effect_sizes(testCase.SimpleLME);
            
            testCase.verifyTrue(isfield(es, 'TermNames'));
            testCase.verifyTrue(isfield(es, 'RawBeta'));
            testCase.verifyTrue(isfield(es, 'CohensD'));
            testCase.verifyTrue(isfield(es, 'StdBeta'));
            testCase.verifyTrue(isfield(es, 'N'));
        end
        
        function testCalculations(testCase)
            % Verify the values match manual calculations based on the formulas
            
            lme = testCase.SimpleLME;
            es = vlt.stats.get_lme_effect_sizes(lme);
            
            % Extract data for manual verification
            y = testCase.TestTable.Response;
            sigma_y = std(y, 'omitnan');
            
            % Get Fixed Effects coefficients
            [betaVector, names] = fixedEffects(lme);
            
            % Get Design Matrix to calculate sigma_x
            X = designMatrix(lme, 'Fixed');
            
            for i = 1:length(betaVector)
                beta = betaVector(i);
                col = X(:, i);
                sigma_x = std(col, 'omitnan');
                
                % Expected values
                expected_CohensD = beta / sigma_y;
                expected_StdBeta = beta * (sigma_x / sigma_y);
                
                % Expected N calculation
                if all(col == 0 | col == 1)
                    expected_N = sum(col);
                else
                    expected_N = length(col);
                end

                % Assertions with tolerance
                testCase.verifyEqual(es.CohensD(i), expected_CohensD, ...
                    'AbsTol', 1e-10, 'Cohen''s D calculation mismatch');
                
                testCase.verifyEqual(es.StdBeta(i), expected_StdBeta, ...
                    'AbsTol', 1e-10, 'Standardized Beta calculation mismatch');

                testCase.verifyEqual(es.N(i), expected_N, ...
                    'N calculation mismatch');
            end
        end

        function testInterceptIsZeroStdBeta(testCase)
            % The standardized beta for the Intercept should theoretically be 0
            % because sigma_x for a column of ones is 0.
            
            es = vlt.stats.get_lme_effect_sizes(testCase.SimpleLME);
            
            % Find the index of the intercept
            idx = find(strcmp(es.TermNames, '(Intercept)'));
            
            testCase.verifyEqual(es.StdBeta(idx), 0, ...
                'Standardized Beta for intercept should be 0');
        end

        function testInteractionError(testCase)
            % Verify that passing a model with interactions throws an error
            
            testCase.verifyError(...
                @() vlt.stats.get_lme_effect_sizes(testCase.InteractionLME), ...
                ?MException); 
            % Note: You can specify a custom error ID if you add one to your function
            % e.g., 'vlt:stats:InteractionsNotSupported'
        end
        
        function testInputValidation(testCase)
            % Verify error if input is not a LinearMixedModel
            notAModel = struct('a', 1);
            testCase.verifyError(...
                @() vlt.stats.get_lme_effect_sizes(notAModel), ...
                ?MException);
        end
    end
end
