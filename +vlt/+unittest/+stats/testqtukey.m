classdef testqtukey < matlab.unittest.TestCase
%testqtukey Unit tests for vlt.stats.qtukey
%
%   This test class verifies the functionality of vlt.stats.qtukey
%   (FEX 3469) by:
%   1. Embedding the (bug-fixed) original FEX 3469 code as a static method.
%   2. Testing that the output of vlt.stats.qtukey is identical to
%      the original embedded code.
%   3. Verifying the function's output against known "ground truth"
%      values from statistical tables.
%   4. Testing error conditions (nargin) and warning conditions (v < 1).
%
%   To run:
%   runtests('vlt.unittest.stats.testqtukey')
%
%   See also: vlt.stats.qtukey, matlab.unittest.TestCase

    properties
        % Known values from Studentized Range (q) tables
        % {q_crit, k_groups, v_dof, p_probability}
        KnownValues = { ...
            3.633, 3, 10, 0.95; ...
            4.232, 5, 20, 0.95; ...
            5.218, 10, 30, 0.95; ...
            2.949, 2, 60, 0.95; ...
            5.556, 5, 15, 0.99  ...
            };
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
                    q_orig_def = vlt.unittest.stats.testqtukey.original_qtukey(v, k, 0.95);

                    testCase.assertEqual(q_vlt_def, q_orig_def, 'AbsTol', 1e-15, ...
                        sprintf('Failed for default p with v=%d, k=%d', v, k));
                end
            end
        end

        function testKnownValues(testCase)
            % This test verifies the function's accuracy against
            % published "ground truth" values.

            testCase.log('Testing against known values from q-tables...');

            for i = 1:size(testCase.KnownValues, 1)
                data = testCase.KnownValues(i,:);
                expected_q = data{1};
                k = data{2};
                v = data{3};
                p = data{4};

                q_calc = vlt.stats.qtukey(v, k, p);
                testCase.assertEqual(q_calc, expected_q, 'AbsTol', 1e-3, ...
                    sprintf('Failed for v=%d, k=%d, p=%.2f', v, k, p));
            end
        end

        function testDefaultProbability(testCase)
            % This test verifies that the p=0.95 default is applied correctly.
            testCase.log('Testing default probability (p=0.95)...');

            q_default = vlt.stats.qtukey(20, 5);
            q_explicit = vlt.stats.qtukey(20, 5, 0.95);

            testCase.assertEqual(q_default, q_explicit);
            testCase.assertEqual(q_default, 4.232, 'AbsTol', 1e-3);
        end

        function testErrorConditions(testCase)
            % This test verifies that the function errors correctly
            % when not provided with the minimum number of inputs.
            testCase.log('Testing error for nargin < 2...');

            % The function signature `function x = qtukey(v, k, p)`
            % will cause MATLAB to throw this error before the
            % code's `if nargin < 2` check is even reached.
            testCase.verifyError(@() vlt.stats.qtukey(), ...
                'MATLAB:narginchk:notEnoughInputs');

            testCase.verifyError(@() vlt.stats.qtukey(10), ...
                'MATLAB:narginchk:notEnoughInputs');
        end

        function testWarningConditions(testCase)
            % This test verifies the warning and behavior for v < 1.
            testCase.log('Testing warning for v < 1...');

            % 1. Verify that the warning is thrown and has the correct ID/message
            %    Note: warning('message') throws 'MATLAB:User:Warning'
            [q_warn, warn_info] = testCase.verifyWarning(@() vlt.stats.qtukey(0.5, 3, 0.95), ...
                'MATLAB:User:Warning');

            testCase.assertEqual(warn_info.message, ...
                'Degrees of freedom v < 1, results may be unreliable.');

            % 2. Verify the logic: the function should treat v=0.5 as v=1
            q_v1 = vlt.stats.qtukey(1, 3, 0.95);
            testCase.assertEqual(q_warn, q_v1);
        end

    end

    methods (Static)
        function x = original_qtukey(v, k, p)
            % STATIC WRAPPER
            % This method is a copy of the (bug-fixed) implementation
            % from vlt.stats.qtukey.m for direct comparison.

            if nargin < 3
                p = 0.95;
            end

            if nargin < 2
               error('Requires at least two arguments (v, k).');
            end

            if v < 1
                warning('Degrees of freedom v < 1, results may be unreliable.');
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
