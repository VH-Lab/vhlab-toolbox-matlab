classdef test_corrcoefResample < matlab.unittest.TestCase
    methods (Test)
        function testBasic(testCase)
            X = [1; 2; 3; 4; 5];
            Y = [1; 2; 3; 4; 5];
            N = 10;
            [rho, rho_perm, percentile] = vlt.stats.corrcoefResample(X, Y, N);
            testCase.verifyEqual(rho, 1);
            testCase.verifySize(rho_perm, [N 1]);
            testCase.verifyTrue(percentile >= 0 && percentile <= 100);
        end

        function testUseRanks(testCase)
            X = [1; 2; 3; 100; 5];
            Y = [1; 2; 3; 4; 5];

            % Check Pearson
            rho_matrix = corrcoef(X, Y);
            rho_pearson = rho_matrix(1,2);

            % Check Spearman (Pearson on ranks)
            Xr = vlt.stats.ranks(X);
            Yr = vlt.stats.ranks(Y);
            rho_matrix_s = corrcoef(Xr, Yr);
            rho_spearman = rho_matrix_s(1,2);

            [rho_out, ~, ~] = vlt.stats.corrcoefResample(X, Y, 10, 'useRanks', true);

            testCase.verifyEqual(rho_out, rho_spearman, 'AbsTol', 1e-10);
            testCase.verifyNotEqual(rho_out, rho_pearson);
        end

        function testDefaultOption(testCase)
             X = [1; 2; 3; 100; 5];
             Y = [1; 2; 3; 4; 5];
             [rho_out, ~, ~] = vlt.stats.corrcoefResample(X, Y, 10);

             rho_matrix = corrcoef(X, Y);
             rho_pearson = rho_matrix(1,2);

             testCase.verifyEqual(rho_out, rho_pearson, 'AbsTol', 1e-10);
        end
    end
end
