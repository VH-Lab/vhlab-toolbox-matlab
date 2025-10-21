classdef testPower2corrcoef < matlab.unittest.TestCase
    % TESTPOWER2CORRCOEF - Test for vlt.stats.power.power2corrcoef
    %

    properties
        OriginalRandStream;
    end

    methods (TestMethodSetup)
        function storeAndResetRandStream(testCase)
            % Store the current random number generator stream and reset it
            % to ensure reproducibility of tests.
            testCase.OriginalRandStream = rng;
            rng('default');
        end
    end

    methods (TestMethodTeardown)
        function restoreRandStream(testCase)
            % Restore the original random number generator stream.
            rng(testCase.OriginalRandStream);
        end
    end

    methods (Test)

        function testFunctionRuns(testCase)
            % Test that the function runs without error for both test types
            sample1 = randn(1, 10);
            sample2 = randn(1, 10);
            correlations = [-0.9, 0, 0.9];

            % Test with 'corrcoef' - runs quickly
            p_corr = vlt.stats.power.power2corrcoef(sample1, sample2, correlations, ...
                'test', 'corrcoef', 'numSimulations', 10, 'plot', false, 'verbose', false);
            testCase.verifyEqual(size(p_corr), size(correlations));

            % Test with 'corrcoefResample' - use minimal settings to ensure it runs
            p_resample = vlt.stats.power.power2corrcoef(sample1, sample2, correlations, ...
                'test', 'corrcoefResample', 'numSimulations', 2, 'resampleNum', 2, 'plot', false, 'verbose', false);
            testCase.verifyEqual(size(p_resample), size(correlations));
        end

        function testPowerCurveShape(testCase)
            % Test that power increases as the absolute value of correlation increases
            sample1 = randn(1, 25);
            sample2 = randn(1, 25);
            correlations = [-0.9, -0.5, 0, 0.5, 0.9];

            p = vlt.stats.power.power2corrcoef(sample1, sample2, correlations, ...
                'numSimulations', 50, 'plot', false, 'verbose', false);

            % Power at |c|=0.9 should be greater than power at |c|=0.5
            testCase.verifyGreaterThan(p(1), p(2), 'Power for c=-0.9 should be > power for c=-0.5');
            testCase.verifyGreaterThan(p(5), p(4), 'Power for c=0.9 should be > power for c=0.5');

            % Power at c=0 should be close to the alpha level (Type I error rate)
            testCase.verifyEqual(p(3), 0.05, 'AbsTol', 0.15, 'Power for c=0 should be near alpha.');
        end

        function testInputValidation(testCase)
            % Test that the function errors correctly with invalid inputs
            sample1 = [1 2 3];
            sample2 = [4 5];
            correlations = [0.5];

            % Mismatched sample sizes
            testCase.verifyError(@() vlt.stats.power.power2corrcoef(sample1, sample2, correlations, 'plot', false), '', ...
                'Should error when sample sizes differ.');

            % Invalid correlation values from arguments block
            sample2_valid = [4 5 6];
            invalid_corrs = [-1.1];
            testCase.verifyError(@() vlt.stats.power.power2corrcoef(sample1, sample2_valid, invalid_corrs, 'plot', false), ...
                'MATLAB:validators:mustBeGreaterThanOrEqual', 'Should error for correlations < -1.');

            invalid_corrs_2 = [1.1];
             testCase.verifyError(@() vlt.stats.power.power2corrcoef(sample1, sample2_valid, invalid_corrs_2, 'plot', false), ...
                'MATLAB:validators:mustBeLessThanOrEqual', 'Should error for correlations > 1.');
        end

    end

end
