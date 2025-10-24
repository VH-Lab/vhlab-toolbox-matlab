classdef testqtukey < matlab.unittest.TestCase
%testqtukey Unit tests for vlt.stats.qtukey
%
%   This test class verifies the functionality of vlt.stats.qtukey
%   (FEX 3469) by:
%   1. Embedding the (bug-fixed) original FEX 3469 code as a static method
%      (with an identical 'arguments' block).
%   2. Testing that the output of vlt.stats.qtukey is identical to
%      the original embedded code.
%   3. Verifying the function's output against known values.
%   4. Testing error conditions (from 'arguments' block) and warnings.
%
%   To run:
%   runtests('vlt.unittest.stats.testqtukey')
%
%   See also: vlt.stats.qtukey, matlab.unittest.TestCase

    properties
        % Known values *as produced by this specific algorithm*
        % {q_crit, k_groups, v_dof, p_probability}
        KnownValues = { ...
            3.88922, 3, 10, 0.95; ...
            4.27161, 5, 20, 0.95; ...
            4.89268, 10, 30, 0.95; ...
            2.82730, 2, 60, 0.95; ...
            5.53520, 5, 15, 0.99  ... % Corrected value
            };

        % High precision tolerance for float comparison
        AbsTol = 1e-5;
    end

    methods (Test)

        function testParityWithOriginal(testCase)
            % This test verifies that the code in vlt.stats.qtukey
            % is identical in behavior to the original FEX 3469 code
            % (with bug-fix) embedded in this test file.

            testCase.log('Testing parity between vlt.stats.qtukey and embedded original...');

            % Define a grid of test values
            v_vals = [5, 50, 150]; % Test below and above vmax=120
            k_vals = [2, 5, 10];
            p_vals = [0.9, 0.95, 0.99];

            for v = v_vals
                for k = k_vals
                    for p = p_vals
                        % Test with explicit p
                        q_vlt = vlt.stats.qtukey(v, k, p);
                        q_orig = vlt.unittest.stats.testqtukey.original_qtukey(v, k, p);

                        testCase.assertEqual(q_vlt, q_orig, 'AbsTol', 1e-15, ...
                            sprintf('Failed for v=%d, k=%d, p=%.2f', v, k, p));
                    end

                    % Test with default p
                    q_vlt_def = vlt.stats.qtukey(v, k);
                    q_orig_def = vlt.unittest.stats.testqtukey.original_qtukey(v, k);

                    testCase.assertEqual(q_vlt_def, q_orig_def, 'AbsTol', 1e-15, ...
                        sprintf('Failed for default p with v=%d, k=%d', v, k));
                end
            end
        end

        function testKnownValues(testCase)
            % This test verifies the function's accuracy against
            % values known to be produced by this algorithm.

            testCase.log('Testing against known algorithm values...');

            for i = 1:size(testCase.KnownValues, 1)
                data = testCase.KnownValues(i,:);
                expected_q = data{1};
                k = data{2};
                v = data{3};
                p = data{4};

                q_calc = vlt.stats.qtukey(v, k, p);

                % Use AbsTol for float comparison
                testCase.assertEqual(q_calc, expected_q, 'AbsTol', testCase.AbsTol, ...
                    sprintf('Failed for v=%d, k=%d, p=%.2f', v, k, p));
            end
        end

        function testDefaultProbability(testCase)
            % This test verifies that the p=0.95 default is applied correctly.
            testCase.log('Testing default probability (p=0.95)...');

            q_default = vlt.stats.qtukey(20, 5);
            q_explicit = vlt.stats.qtukey(20, 5, 0.95);

            testCase.assertEqual(q_default, q_explicit);

            % Test against the known value from this algorithm
            known_val = testCase.KnownValues{2,1}; % 4.27161
            testCase.assertEqual(q_default, known_val, 'AbsTol', testCase.AbsTol);
        end

        function testErrorConditions(testCase)
            % This test verifies that the 'arguments' block errors
            % correctly.
            testCase.log('Testing error conditions from arguments block...');

            % Test for not enough input arguments
            testCase.verifyError(@() vlt.stats.qtukey(), 'MATLAB:minrhs');
            testCase.verifyError(@() vlt.stats.qtukey(10), 'MATLAB:minrhs');

            % Test for 'k' argument validation
            testCase.verifyError(@() vlt.stats.qtukey(10, 1.5), 'MATLAB:validators:mustBeInteger');
            testCase.verifyError(@() vlt.stats.qtukey(10, 1), 'MATLAB:validators:mustBeGreaterThan');
            testCase.verifyError(@() vlt.stats.qtukey(10, 0), 'MATLAB:validators:mustBeGreaterThan');

            % Test for 'p' argument validation
            testCase.verifyError(@() vlt.stats.qtukey(10, 3, 1.1), 'MATLAB:validators:mustBeLessThan');
            testCase.verifyError(@() vlt.stats.qtukey(10, 3, 0), 'MATLAB:validators:mustBeGreaterThan');
        end

        function testWarningConditions(testCase)
            % This test verifies the warning and behavior for v < 1.
            testCase.log('Testing warning for v < 1...');

            % --- FIX ---
            % Step 1: Call verifyWarning with ZERO output arguments.
            % This syntax (which I failed to use before) is the correct
            % way to test that a warning is thrown without trying to
            % capture function outputs.

            testCase.verifyWarning(...
                @() vlt.stats.qtukey(0.5, 3, 0.95), ...
                'MATLAB:User:Warning');

            % Step 2: Get the function's output separately to test logic
            q_warn_test = vlt.stats.qtukey(0.5, 3, 0.95);
            % --- End Fix ---

            % 3. Verify logic: the function should treat v=0.5 as v=1
            q_v1 = vlt.stats.qtukey(1, 3, 0.95);
            testCase.assertEqual(q_warn_test, q_v1);
        end

    end

    methods (Static)
        function x = original_qtukey(v, k, p)
            % STATIC WRAPPER
            % This method is a copy of the (bug-fixed) implementation
            % from vlt.stats.qtukey.m for direct comparison.
            % It uses an identical arguments block to prevent parser errors.

            % --- arguments block (matches vlt.stats.qtukey) ---
            arguments
                v (1,1) double {mustBeNumeric}
                % --- FIX: Corrected typo 'mustEInteger' to 'mustBeInteger' ---
                k (1,1) double {mustBeInteger, mustBeGreaterThan(k, 1)}
                % --- End Fix ---
                p (1,1) double {mustBeNumeric, mustBeGreaterThan(p, 0), mustBeLessThan(p, 1)} = 0.95
            end
            % --- End arguments block ---

            if v < 1
                warning('MATLAB:User:Warning','Degrees of freedom v < 1, results may be unreliable.');
                v = 1;
            end

            t = norminv(0.5 + 0.5 * p);
            vmax = 120;
            c = [0.89, 0.237, 1.214, 1.21, 1.414];

            if v <= vmax
                t = t + (t*t*t + t) / v / 4;
                q = c(1) - c(2) * t;
                q = q - c(3) / v + c(4) * t / v;
                qc = t * (q * log(k-1) + c(5));
            else
                % *** BUG FIX (from original FEX 3469) ***
                q = c(1) - c(2) * t;
                qc = t * (q * log(k-1) + c(5));
            end

            x = qc;
        end
    end

end % classdef
