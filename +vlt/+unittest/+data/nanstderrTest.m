classdef nanstderrTest < matlab.unittest.TestCase
    methods (Test)
        function testVectorWithNaNs(testCase)
            data = [1 2 NaN 4 5];
            se = vlt.data.nanstderr(data);
            expected_se = nanstd(data) / sqrt(4);
            testCase.verifyEqual(se, expected_se, 'AbsTol', 1e-10);
        end

        function testMatrixWithNaNs(testCase)
            data = [1 2 NaN 4 5; 6 NaN 8 9 10]';
            se = vlt.data.nanstderr(data);
            expected_se1 = nanstd(data(:,1)) / sqrt(4);
            expected_se2 = nanstd(data(:,2)) / sqrt(4);
            testCase.verifyEqual(se(1), expected_se1, 'AbsTol', 1e-10);
            testCase.verifyEqual(se(2), expected_se2, 'AbsTol', 1e-10);
        end
    end
end
