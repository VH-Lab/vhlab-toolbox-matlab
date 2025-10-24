classdef testImposeCorrelationByReordering < matlab.unittest.TestCase
    % TESTIMPOSECORRELATIONBYREORDERING - Test for vlt.stats.power.imposeCorrelationByReordering
    %

    methods (Test)

        function testPreservesMarginalDistributions(testCase)
            % Test that the output vectors contain the exact same values as the inputs

            n_samples = 100;
            X_orig = rand(n_samples, 1) * 10;
            Y_orig = randn(n_samples, 1) * 5;
            target_corr = 0.75;

            [X_new, Y_new] = vlt.stats.power.imposeCorrelationByReordering(X_orig, Y_orig, target_corr);

            % Verify that the sorted values are identical
            testCase.verifyEqual(sort(X_orig), sort(X_new), 'AbsTol', 1e-9, ...
                'The set of values in Xhat should be identical to the set of values in X.');
            testCase.verifyEqual(sort(Y_orig), sort(Y_new), 'AbsTol', 1e-9, ...
                'The set of values in Yhat should be identical to the set of values in Y.');
        end

        function testAchievesTargetCorrelation(testCase)
            % Test that the Spearman's rank correlation of the output is close to the target

            n_samples = 500; % Larger sample size for more stable correlation
            X_orig = linspace(-10, 10, n_samples)';
            Y_orig = exprnd(1, n_samples, 1); % Exponential distribution

            % Test with a positive target correlation
            target_pos = 0.8;
            [X_pos, Y_pos] = vlt.stats.power.imposeCorrelationByReordering(X_orig, Y_orig, target_pos);
            final_corr_pos = corr(X_pos, Y_pos, 'Type', 'Spearman');
            testCase.verifyEqual(final_corr_pos, target_pos, 'AbsTol', 0.05, ...
                'The final Spearman correlation should be close to the positive target.');

            % Test with a negative target correlation
            target_neg = -0.6;
            [X_neg, Y_neg] = vlt.stats.power.imposeCorrelationByReordering(X_orig, Y_orig, target_neg);
            final_corr_neg = corr(X_neg, Y_neg, 'Type', 'Spearman');
            testCase.verifyEqual(final_corr_neg, target_neg, 'AbsTol', 0.08, ...
                'The final Spearman correlation should be close to the negative target.');

            % Test with a near-zero target correlation
            target_zero = 0.0;
            [X_zero, Y_zero] = vlt.stats.power.imposeCorrelationByReordering(X_orig, Y_orig, target_zero);
            final_corr_zero = corr(X_zero, Y_zero, 'Type', 'Spearman');
            testCase.verifyEqual(final_corr_zero, target_zero, 'AbsTol', 0.1, ... % Higher tolerance near zero
                'The final Spearman correlation should be close to zero.');
        end

        function testInputValidation(testCase)
            % Test that the function errors correctly with invalid inputs

            % Mismatched sizes
            X1 = [1 2 3];
            Y1 = [4 5];
            testCase.verifyError(@() vlt.stats.power.imposeCorrelationByReordering(X1, Y1, 0.5), '', ...
                'Should error when X and Y have different numbers of elements.');

            % Invalid correlation value
            X2 = [1 2 3];
            Y2 = [4 5 6];
            testCase.verifyError(@() vlt.stats.power.imposeCorrelationByReordering(X2, Y2, 1.1), '', ...
                'Should error when c is > 1.');
            testCase.verifyError(@() vlt.stats.power.imposeCorrelationByReordering(X2, Y2, -1.1), '', ...
                'Should error when c is < -1.');
            testCase.verifyError(@() vlt.stats.power.imposeCorrelationByReordering(X2, Y2, [0.5 0.5]), '', ...
                'Should error when c is not a scalar.');
        end

        function testHandlesRowAndColumnVectors(testCase)
            % Test that the function works with both row and column vector inputs

            n_samples = 500;
            X_col = randn(n_samples, 1);
            Y_col = randn(n_samples, 1);
            X_row = X_col';
            Y_row = Y_col';
            target_corr = -0.5;

            % This should run without error
            [X_hat_col, Y_hat_col] = vlt.stats.power.imposeCorrelationByReordering(X_col, Y_col, target_corr);
            [X_hat_row, Y_hat_row] = vlt.stats.power.imposeCorrelationByReordering(X_row, Y_row, target_corr);

            % Check that the outputs are columns, as expected by the function's implementation
            testCase.verifyTrue(iscolumn(X_hat_col));
            testCase.verifyTrue(iscolumn(Y_hat_col));

            % The function internally converts rows to columns, so the row input should also produce column output
            testCase.verifyTrue(iscolumn(X_hat_row));
            testCase.verifyTrue(iscolumn(Y_hat_row));

            % And the final correlation should still be correct
            final_corr_row = corr(X_hat_row, Y_hat_row, 'Type', 'Spearman');
            testCase.verifyEqual(final_corr_row, target_corr, 'AbsTol', 0.15);
        end

    end

end
