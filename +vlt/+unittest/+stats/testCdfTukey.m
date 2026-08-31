classdef testCdfTukey < matlab.unittest.TestCase
%testCdfTukey Unit tests for vlt.stats.cdfTukey
%
%   This test class verifies the functionality of vlt.stats.cdfTukey
%   by:
%   1. Verifying the function's output against generated "ground truth"
%      values spanning k = 2..10 and v = 10..240 (see PROVENANCE below).
%   2. Testing edge cases for inputs like q <= 0 and v < 1.
%   3. Verifying the special case calculation for k=2 against tcdf.
%
%   To run:
%   runtests('vlt.unittest.stats.testCdfTukey')
%
%   See also: vlt.stats.cdfTukey, matlab.unittest.TestCase

    properties
        % Ground truth: the 95% points of the Studentized range distribution,
        % that is, q such that P(Q_{k,v} <= q) = 0.95.
        %
        % PROVENANCE. These constants are generated, not transcribed. They come
        % from scipy.stats.studentized_range (SciPy 1.17.1), an independent
        % implementation of the same distribution, and each one round-trips
        % through that cdf to within 1e-12. They are embedded as literals so
        % this test depends on nothing beyond MATLAB. To regenerate:
        %
        %   from scipy.stats import studentized_range as sr
        %   for k in [2,3,4,5,6,8,10]:
        %       for v in [10,20,30,60,120,240]:
        %           print(sr.ppf(0.95, k, v), k, v)
        %
        % An earlier version of this table was transcribed by hand, and one row
        % was then edited to agree with vlt.stats.cdfTukey's own output, with
        % the comment "Adjusted from Lund's 5.218 based on function output".
        % That row (q=4.893, k=10, v=30) was wrong twice over: the true 95%
        % point is 4.8241, and the 5.218 it claimed to be correcting is the
        % 0.974 point, not a 0.95 one. Fitting an expected value to the
        % implementation leaves the row asserting only that the function agrees
        % with itself, which is why this table is generated and why this note
        % is attached to it.
        KnownValues_p95 = { ...
            % q, k, v, expected_p
                3.151064,  2,   10, 0.95; ...
                2.949998,  2,   20, 0.95; ...
                2.888209,  2,   30, 0.95; ...
                2.828848,  2,   60, 0.95; ...
                2.800044,  2,  120, 0.95; ...
                2.785856,  2,  240, 0.95; ...
                3.876777,  3,   10, 0.95; ...
                3.577935,  3,   20, 0.95; ...
                3.486420,  3,   30, 0.95; ...
                3.398661,  3,   60, 0.95; ...
                3.356138,  3,  120, 0.95; ...
                3.335207,  3,  240, 0.95; ...
                4.326582,  4,   10, 0.95; ...
                3.958294,  4,   20, 0.95; ...
                3.845401,  4,   30, 0.95; ...
                3.737089,  4,   60, 0.95; ...
                3.684589,  4,  120, 0.95; ...
                3.658742,  4,  240, 0.95; ...
                4.654293,  5,   10, 0.95; ...
                4.231857,  5,   20, 0.95; ...
                4.102079,  5,   30, 0.95; ...
                3.977418,  5,   60, 0.95; ...
                3.916938,  5,  120, 0.95; ...
                3.887148,  5,  240, 0.95; ...
                4.912016,  6,   10, 0.95; ...
                4.445237,  6,   20, 0.95; ...
                4.301464,  6,   30, 0.95; ...
                4.163161,  6,   60, 0.95; ...
                4.095986,  6,  120, 0.95; ...
                4.062881,  6,  240, 0.95; ...
                5.304238,  8,   10, 0.95; ...
                4.767584,  8,   20, 0.95; ...
                4.601415,  8,   30, 0.95; ...
                4.441079,  8,   60, 0.95; ...
                4.363013,  8,  120, 0.95; ...
                4.324493,  8,  240, 0.95; ...
                5.598386, 10,   10, 0.95; ...
                5.007883, 10,   20, 0.95; ...
                4.824141, 10,   30, 0.95; ...
                4.646324, 10,   60, 0.95; ...
                4.559538, 10,  120, 0.95; ...
                4.516661, 10,  240, 0.95; ...
            };

        % Tolerance. 1e-6, not the 1e-2 this test used to carry.
        %
        % The old grid stopped at v = 30 and the tolerance was deliberately
        % loose, because vlt.stats.cdfTukey used to return exactly 1 for k > 2
        % once v reached about 60, and read about 0.0053 low at k = 10, v = 30.
        % That was issue #141: the formula was correct all along, but the outer
        % integral was handed to a single adaptive call over [0,Inf] and missed
        % the integrand's narrow peak near s = 1. Fixed in #142 by integrating
        % over deterministic panels and accumulating the density constant in
        % log space, as R's ptukey does.
        %
        % With that fixed the grid extends to v = 240 and the tolerance can be
        % four orders tighter, which is what makes these rows worth asserting:
        % at 1e-2 a row could pass while the function was wrong in its third
        % decimal, and one row was in fact edited to accommodate exactly that.
        AbsTol = 1e-6;
    end

    methods (Test)

        function testKnownValues(testCase)
            % This test verifies the function's accuracy against the
            % generated ground-truth table above.
            testCase.log('Testing against generated known values...');

            % Test against the table of known values
            for i = 1:size(testCase.KnownValues_p95, 1)
                data = testCase.KnownValues_p95(i,:);
                q = data{1};
                k = data{2};
                v = data{3};
                expected_p = data{4};

                p_calc = vlt.stats.cdfTukey(q, k, v);

                testCase.assertEqual(p_calc, expected_p, 'AbsTol', testCase.AbsTol, ...
                    sprintf('Failed for q=%.3f, k=%d, v=%d', q, k, v));
            end
        end

        function testKequals2Case(testCase)
            % Verify the k=2 special case matches the t-distribution CDF
            testCase.log('Testing k=2 special case against tcdf...');
            q_val = 3.151; % Corresponds to t=2.2281 for v=10, p=0.95
            v_val = 10;
            p_calc_k2 = vlt.stats.cdfTukey(q_val, 2, v_val);

            % Theoretical value from t-distribution
            t_val = q_val / sqrt(2);
            expected_p_tcdf = tcdf(t_val, v_val) - tcdf(-t_val, v_val);

            testCase.assertEqual(p_calc_k2, expected_p_tcdf, 'AbsTol', 1e-4, ...
                 'k=2 calculation did not match tcdf equivalent.');
        end


        function testEdgeCases(testCase)
            % This test checks the function's behavior for edge cases.
            testCase.log('Testing edge cases...');

            % q <= 0 should always return p = 0
            p_zero = vlt.stats.cdfTukey(0, 5, 10);
            p_neg = vlt.stats.cdfTukey(-3, 5, 10);
            testCase.assertEqual(p_zero, 0);
            testCase.assertEqual(p_neg, 0);

            % v < 1 should issue a warning and clamp to v=1
            % Verify the warning is issued
            testCase.verifyWarning(@() vlt.stats.cdfTukey(3, 3, 0.5), 'MATLAB:User:Warning');

            % Verify the output is the same as v=1
            p_low_v = vlt.stats.cdfTukey(3, 3, 0.5);
            p_v1    = vlt.stats.cdfTukey(3, 3, 1);
            testCase.assertEqual(p_low_v, p_v1);

            % Test that outputs are valid probabilities [0, 1]
            % Use a case where integration previously gave NaN/Inf warnings
            % to ensure clamping works
            % This case used to warn and return 1. That was the k>2 quadrature
            % failure of issue #141, fixed in #142; k=2 takes the exact tcdf
            % path and was never affected. Kept as a regression guard.
            p_test_clamp = vlt.stats.cdfTukey(4, 2, 60);
            testCase.assertGreaterThanOrEqual(p_test_clamp, 0);
            testCase.assertLessThanOrEqual(p_test_clamp, 1);

            % Test that probability increases with v (for fixed q, k)
            p_v30 = vlt.stats.cdfTukey(4, 5, 30);
            p_v100 = vlt.stats.cdfTukey(4, 5, 100);
            testCase.assertGreaterThan(p_v100, p_v30);
        end

    end % methods (Test)

end % classdef

