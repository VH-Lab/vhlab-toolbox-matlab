classdef testHedgesG < matlab.unittest.TestCase

    methods (Test)

        function testBasic(testCase)
            % Test with simple known values
            A = [1, 2, 3];
            B = [4, 5, 6];
            % Means: 2, 5. Diff: -3.
            % Vars: 1, 1.
            % s_pool: sqrt((2*1 + 2*1)/4) = 1.
            % d: -3 / 1 = -3.
            % J: 1 - 3 / (4*6 - 9) = 1 - 3/15 = 1 - 0.2 = 0.8.
            % g: -3 * 0.8 = -2.4.

            g = vlt.stats.hedgesG(A, B);
            testCase.verifyEqual(g, -2.4, 'AbsTol', 1e-10, 'Basic calculation failed');
        end

        function testIdentical(testCase)
            % Test with identical samples
            A = [1, 2, 3];
            B = [1, 2, 3];
            g = vlt.stats.hedgesG(A, B);
            testCase.verifyEqual(g, 0, 'AbsTol', 1e-10, 'Identical samples should yield 0');
        end

        function testNaNs(testCase)
            % Test NaN handling
            A = [1, 2, 3];
            B = [4, 5, 6];
            A_nan = [1, NaN, 2, 3];
            B_nan = [4, 5, NaN, 6];

            g = vlt.stats.hedgesG(A, B);
            g_nan = vlt.stats.hedgesG(A_nan, B_nan);

            testCase.verifyEqual(g_nan, g, 'AbsTol', 1e-10, 'NaNs should be ignored');
        end

        function testEmpty(testCase)
            % Test with empty inputs
            A = [];
            B = [1, 2, 3];
            g = vlt.stats.hedgesG(A, B);
            testCase.verifyTrue(isnan(g), 'Empty input should result in NaN');

            g = vlt.stats.hedgesG(B, A);
            testCase.verifyTrue(isnan(g), 'Empty input should result in NaN');

            g = vlt.stats.hedgesG([], []);
            testCase.verifyTrue(isnan(g), 'Empty inputs should result in NaN');
        end

        function testSingleElement(testCase)
            % Test with single element arrays (variance undefined)
            A = [1];
            B = [1, 2, 3];
            g = vlt.stats.hedgesG(A, B);
            testCase.verifyTrue(isnan(g), 'Single element input should result in NaN');
        end

        function testZeroVarianceDiffMeans(testCase)
            % Test with zero variance but different means
            A = [1, 1, 1];
            B = [2, 2, 2];
            % Means: 1, 2. Diff: -1.
            % Vars: 0, 0. s_pool: 0.
            % d: -1/0 = -Inf.
            g = vlt.stats.hedgesG(A, B);
            testCase.verifyEqual(g, -Inf, 'Zero pooled variance with different means should be Inf or -Inf');
        end

        function testZeroVarianceSameMeans(testCase)
            % Test with zero variance and same means
            A = [1, 1, 1];
            B = [1, 1, 1];
            g = vlt.stats.hedgesG(A, B);
            testCase.verifyEqual(g, 0, 'Zero pooled variance with same means should be 0');
        end

        function testLargeSample(testCase)
            % Test with large sample size where J approaches 1
            A = randn(1000, 1);
            B = randn(1000, 1) + 1;

            m1 = mean(A); m2 = mean(B);
            s1 = std(A); s2 = std(B);
            n1 = 1000; n2 = 1000;
            s_pool = sqrt(((n1-1)*s1^2 + (n2-1)*s2^2)/(n1+n2-2));
            d = (m1 - m2) / s_pool;
            J = 1 - 3/(4*(n1+n2)-9);
            expected_g = d * J;

            g = vlt.stats.hedgesG(A, B);
            testCase.verifyEqual(g, expected_g, 'AbsTol', 1e-10, 'Large sample calculation mismatch');
        end

         function testEdgeCaseInputShape(testCase)
            % Test with row vectors vs column vectors
            A = [1, 2, 3];
            B = [4; 5; 6];
            g = vlt.stats.hedgesG(A, B);
            testCase.verifyEqual(g, -2.4, 'AbsTol', 1e-10, 'Shape mismatch handling failed');
        end
    end
end
