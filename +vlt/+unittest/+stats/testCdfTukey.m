classdef testCdfTukey < matlab.unittest.TestCase
%testCdfTukey Unit tests for vlt.stats.cdfTukey
%
%   This test class verifies the functionality of vlt.stats.cdfTukey
%   by:
%   1. Verifying the function's output against known "ground truth"
%      values from statistical tables.
%   2. Testing edge cases for inputs like q <= 0 and non-integer v.
%
%   To run:
%   runtests('vlt.unittest.stats.testCdfTukey')
%
%   See also: vlt.stats.cdfTukey, matlab.unittest.TestCase

    properties
        % Known values from Studentized Range (q) tables, P = 0.95
        KnownValues_p95 = { ...
            % q, k, v, expected_p
            3.633, 3, 10, 0.95; ...
            4.232, 5, 20, 0.95; ...
            5.218, 10, 30, 0.95; ...
            2.949, 2, 60, 0.95  ...
            };
    end

    methods (Test)

        function testKnownValues(testCase)
            % This test verifies the function's accuracy against
            % published "ground truth" values.

            testCase.log('Testing against known values from q-tables...');

            % Test against k=2 (related to t-distribution)
            % t_crit(alpha=0.05/2, v=10) = 2.2281
            % q_crit = t_crit * sqrt(2) = 3.151
            p_t_test = vlt.stats.cdfTukey(2.2281 * sqrt(2), 2, 10);
            testCase.assertEqual(p_t_test, 0.95, 'AbsTol', 1e-2);

            % Test against the table of known values
            for i = 1:size(testCase.KnownValues_p95, 1)
                data = testCase.KnownValues_p95(i,:);
                q = data{1};
                k = data{2};
                v = data{3};
                expected_p = data{4};

                p_calc = vlt.stats.cdfTukey(q, k, v);
                testCase.assertEqual(p_calc, expected_p, 'AbsTol', 1e-2, ...
                    sprintf('Failed for q=%.3f, k=%d, v=%d', q, k, v));
            end
        end

        function testEdgeCases(testCase)
            % This test checks the function's behavior for edge cases,
            % such as q <= 0 and non-integer/out-of-range v.

            testCase.log('Testing edge cases...');

            % q <= 0 should always return p = 0
            p_zero = vlt.stats.cdfTukey(0, 5, 10);
            p_neg = vlt.stats.cdfTukey(-3, 5, 10);
            testCase.assertEqual(p_zero, 0);
            testCase.assertEqual(p_neg, 0);

            % v < 1 should issue a warning and clamp to v=1
            testCase.verifyWarning(@() vlt.stats.cdfTukey(3, 3, 0.5), 'MATLAB:User:Warning');
            p_low_v = vlt.stats.cdfTukey(3, 3, 0.5);
            p_v1    = vlt.stats.cdfTukey(3, 3, 1);
            testCase.assertEqual(p_low_v, p_v1);

            % v > 19 should still produce valid probabilities
            p_v30 = vlt.stats.cdfTukey(4, 5, 30);
            p_v100 = vlt.stats.cdfTukey(4, 5, 100);

            % Test that outputs are valid probabilities [0, 1]
            testCase.assertGreaterThanOrEqual(p_v30, 0);
            testCase.assertLessThanOrEqual(p_v30, 1);
            testCase.assertGreaterThanOrEqual(p_v100, 0);
            testCase.assertLessThanOrEqual(p_v100, 1);

            % Test that probability increases with v (for fixed q, k)
            testCase.assertGreaterThan(p_v100, p_v30);
        end

    end

end % classdef
