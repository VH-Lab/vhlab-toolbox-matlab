classdef test_nanstderr < matlab.unittest.TestCase
    % TEST_NANSTDERR - tests for the vlt.data.nanstderr function

    methods (Test)

        function test_nanstderr_calculation(testCase)
            % Test case 1: No NaNs
            data1 = [1 2 3 4 5];
            expected_se1 = std(data1) / sqrt(5);
            se1 = vlt.data.nanstderr(data1);
            testCase.verifyEqual(se1, expected_se1, 'AbsTol', 1e-9);

            % Test case 2: With NaNs
            data2 = [1 2 NaN 4 5];
            expected_se2 = nanstd(data2) / sqrt(4);
            se2 = vlt.data.nanstderr(data2);
            testCase.verifyEqual(se2, expected_se2, 'AbsTol', 1e-9);

            % Test case 3: Column-wise
            data3 = [1 6; 2 7; 3 8; 4 9; 5 10];
            expected_se3 = [std(data3(:,1))/sqrt(5) std(data3(:,2))/sqrt(5)];
            se3 = vlt.data.nanstderr(data3);
            testCase.verifyEqual(se3, expected_se3, 'AbsTol', 1e-9);

            % Test case 4: Column-wise with NaNs
            data4 = [1 6; 2 NaN; 3 8; 4 9; 5 10];
            expected_se4 = [std(data4(:,1))/sqrt(5) nanstd(data4(:,2))/sqrt(4)];
            se4 = vlt.data.nanstderr(data4);
            testCase.verifyEqual(se4, expected_se4, 'AbsTol', 1e-9);
        end % test_nanstderr_calculation

    end; % methods (Test)

end
