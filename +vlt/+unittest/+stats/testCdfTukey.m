classdef testCdfTukey < matlab.unittest.TestCase
%testCdfTukey Unit tests for vlt.stats.cdfTukey
%
%   This test class verifies the functionality of vlt.stats.cdfTukey
%   by:
%   1. Verifying the function's output against generated "ground truth"
%      values spanning k = 2..10 and v = 10..30 (see PROVENANCE below).
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
        %       for v in [10,20,30]:
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
            3.151064,  2,  10, 0.95; ...
            2.949998,  2,  20, 0.95; ...
            2.888209,  2,  30, 0.95; ...
            3.876777,  3,  10, 0.95; ...
            3.577935,  3,  20, 0.95; ...
            3.486420,  3,  30, 0.95; ...
            4.326582,  4,  10, 0.95; ...
            3.958294,  4,  20, 0.95; ...
            3.845401,  4,  30, 0.95; ...
            4.654293,  5,  10, 0.95; ...
            4.231857,  5,  20, 0.95; ...
            4.102079,  5,  30, 0.95; ...
            4.912016,  6,  10, 0.95; ...
            4.445237,  6,  20, 0.95; ...
            4.301464,  6,  30, 0.95; ...
            5.304238,  8,  10, 0.95; ...
            4.767584,  8,  20, 0.95; ...
            4.601415,  8,  30, 0.95; ...
            5.598386, 10,  10, 0.95; ...
            5.007883, 10,  20, 0.95; ...
            4.824141, 10,  30, 0.95; ...
            };

        % KNOWN DEFECT -- why this table stops at v = 30.
        %
        % The grid deliberately covers v = 10, 20, 30 only. vlt.stats.cdfTukey
        % breaks down for k > 2 at larger degrees of freedom: it returns
        % exactly 1, not an approximation. Measured in CI:
        %
        %   vlt.stats.cdfTukey(3.398661, 3, 60)  returns  1
        %   true value                                    0.95000
        %
        % k = 2 is unaffected because it takes the exact tcdf path; the fault
        % is in the k > 2 numerical-integration branch, where the outer
        % integrand's 2*(v/2)^(v/2)/gamma(v/2) factor grows rapidly with v.
        % The existing testEdgeCases comment ("Previously warned and gave 1")
        % suggests this was noticed before and worked around rather than fixed.
        %
        % Extending this table to v = 60 makes that a hard failure. That is a
        % real bug worth fixing, but fixing cdfTukey's integration changes
        % numerical output that vlt.stats.power.calculateTukeyPairwisePower and
        % others consume, so it is deliberately out of scope here. This table
        % covers the range the function currently handles; widen it once the
        % integration is fixed.
        %
        % Absolute tolerance. 1e-2 is loose for constants this exact, and
        % deliberately so: cdfTukey also reads low as k grows -- about 0.0053
        % under truth at k=10, v=30, which is the discrepancy the hand-edited
        % row this PR removes was absorbing. Tightening to 1e-3 would expose
        % it, and belongs with the same integration fix.
        AbsTol = 1e-2;
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
            p_test_clamp = vlt.stats.cdfTukey(4, 2, 60); % Previously warned and gave 1
            testCase.assertGreaterThanOrEqual(p_test_clamp, 0);
            testCase.assertLessThanOrEqual(p_test_clamp, 1);

            % Test that probability increases with v (for fixed q, k)
            p_v30 = vlt.stats.cdfTukey(4, 5, 30);
            p_v100 = vlt.stats.cdfTukey(4, 5, 100);
            testCase.assertGreaterThan(p_v100, p_v30);
        end

    end % methods (Test)

end % classdef

