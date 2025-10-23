classdef testcalculateTukeyPairwisePower < matlab.unittest.TestCase
%TESTCALCULATETUKEYPAIRWISEPOWER Unit tests for vlt.stats.power.calculateTukeyPairwisePower
%
%   This test class verifies the functionality of the
%   vlt.stats.power.calculateTukeyPairwisePower function.
%
%   To run:
%   runtests('vlt.unittest.stats.power.testcalculateTukeyPairwisePower')
%
%   See also: vlt.stats.power.calculateTukeyPairwisePower, matlab.unittest.TestCase

    methods (Test)

        function testBasicCalculation(testCase)
            % Test a standard 1-way ANOVA scenario (k=3)
            diff = 3;
            mse = 4; % (SD=2)
            n = 10;
            k = 3;
            alpha = 0.05;

            % Test with default 'cdfTukey' method
            power_cdf = vlt.stats.power.calculateTukeyPairwisePower(diff, mse, n, k, alpha);
            testCase.verifyGreaterThan(power_cdf, 0.80); % Expect high power
            testCase.verifyLessThan(power_cdf, 0.85);    % But not extremely high

            % Test with 'qTukey' method
            power_q = vlt.stats.power.calculateTukeyPairwisePower(diff, mse, n, k, alpha, 'method', 'qTukey');

            % The two methods should be very close
            testCase.assertEqual(power_cdf, power_q, 'AbsTol', 1e-3);
        end

        function testMonotonicity(testCase)
            % Test that power behaves logically as parameters change

            % Baseline parameters
            diff = 3; mse = 4; n = 10; k = 4; alpha = 0.05;

            p_baseline = vlt.stats.power.calculateTukeyPairwisePower(diff, mse, n, k, alpha);

            % 1. Power should INCREASE with larger effect size
            p_high_diff = vlt.stats.power.calculateTukeyPairwisePower(diff + 2, mse, n, k, alpha);
            testCase.verifyGreaterThan(p_high_diff, p_baseline);

            % 2. Power should DECREASE with larger variance (MSE)
            p_high_mse = vlt.stats.power.calculateTukeyPairwisePower(diff, mse + 3, n, k, alpha);
            testCase.verifyLessThan(p_high_mse, p_baseline);

            % 3. Power should INCREASE with larger sample size (n)
            p_high_n = vlt.stats.power.calculateTukeyPairwisePower(diff, mse, n + 5, k, alpha);
            testCase.verifyGreaterThan(p_high_n, p_baseline);

            % 4. Power should DECREASE with more groups (k) due to larger correction
            p_high_k = vlt.stats.power.calculateTukeyPairwisePower(diff, mse, n, k + 3, alpha);
            testCase.verifyLessThan(p_high_k, p_baseline);

            % 5. Power should DECREASE with stricter alpha
            p_low_alpha = vlt.stats.power.calculateTukeyPairwisePower(diff, mse, n, k, alpha / 5);
            testCase.verifyLessThan(p_low_alpha, p_baseline);
        end

        function testInputValidation(testCase)
            % Test that the input parser correctly rejects invalid inputs

            % Test non-integer nPerGroup
            testCase.verifyError(...
                @() vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10.5, 3, 0.05), ...
                'MATLAB:InputParser:ArgumentFailedValidation');

            % Test nPerGroup <= 1
            testCase.verifyError(...
                @() vlt.stats.power.calculateTukeyPairwisePower(3, 4, 1, 3, 0.05), ...
                'MATLAB:InputParser:ArgumentFailedValidation');

            % Test alpha out of bounds
            testCase.verifyError(...
                @() vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 3, 1.1), ...
                'MATLAB:InputParser:ArgumentFailedValidation');

            % Test kTotalGroups < 2
            testCase.verifyError(...
                @() vlt.stats.power.calculateTukeyPairwisePower(3, 4, 10, 1, 0.05), ...
                'MATLAB:InputParser:ArgumentFailedValidation');
        end

    end

end % classdef
