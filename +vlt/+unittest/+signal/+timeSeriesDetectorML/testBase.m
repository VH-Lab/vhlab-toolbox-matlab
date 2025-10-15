classdef testBase < matlab.unittest.TestCase
    properties
        t_vec = (0:0.001:1-0.001)';
        d_vec = randn(1000,1);
        detectorSamples = 5;
    end
    methods (Test)
        function testBasicPositiveCase(testCase)
            stamps = [0.5];
            [obs, tf, new_stamps, labels] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'examplesArePositives', true, ...
                'jitterPositive', false, 'makeShoulderNegatives', false);
            testCase.verifyEqual(size(obs), [testCase.detectorSamples, 1]);
            testCase.verifyTrue(all(tf));
            testCase.verifyEqual(stamps, new_stamps, 'AbsTol', 1e-9);
            testCase.verifyEqual(labels, {"originalPositive"});
        end

        function testBasicNegativeCase(testCase)
            stamps = [0.5];
            [~, tf, ~, labels] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'examplesArePositives', false, ...
                'jitterPositive', false, 'makeShoulderNegatives', false);
            testCase.verifyEqual(labels, {"originalNegative"});
        end

        function testJitter(testCase)
            stamps = [0.5];
            jitterRange = 0.002;
            [~, tf, ~, labels] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'jitterPositive', true, 'jitterRange', jitterRange, ...
                'makeShoulderNegatives', false);

            testCase.verifyTrue(all(tf));
            testCase.verifyEqual(sum(strcmp(labels, "originalPositive")), 1);
            testCase.verifyEqual(sum(strcmp(labels, "jitterPositive")), 4);
        end

        function testShoulderNegatives(testCase)
            stamps = [0.5];
            [~, tf, ~, labels] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'jitterPositive', false, ...
                'makeShoulderNegatives', true, 'shoulderRangeStart', 0.010, 'shoulderRangeStop', 0.012);

            testCase.verifyEqual(sum(tf), 1);
            testCase.verifyEqual(sum(~tf), 6);
            testCase.verifyEqual(sum(strcmp(labels, "originalPositive")), 1);
            testCase.verifyEqual(sum(strcmp(labels, "shoulderNegative")), 6);
        end

        function testPeakFindingOrder(testCase)
            % Test that peak finding happens before jitter and shoulder generation
            stamps = [0.5];
            testCase.d_vec(502) = 10; % peak at t=0.501

            [~, ~, new_stamps, labels] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'optimizeForPeak', true, ...
                'jitterPositive', true, 'makeShoulderNegatives', true);

            % Find the original stamp and verify it was corrected
            original_idx = find(strcmp(labels, "originalPositive"));
            testCase.verifyEqual(new_stamps(original_idx), 0.501, 'AbsTol', 1e-9);

            % Verify that jitter and shoulder stamps are based on the corrected peak
            jitter_idx = find(strcmp(labels, "jitterPositive"));
            shoulder_idx = find(strcmp(labels, "shoulderNegative"));

            testCase.verifyTrue(all(abs(new_stamps(jitter_idx) - 0.501) <= 0.002 + 1e-9));
            testCase.verifyTrue(all(abs(new_stamps(shoulder_idx) - 0.501) >= 0.010 - 1e-9));
        end
    end
end