classdef testBase < matlab.unittest.TestCase
    properties
        t_vec = (0:0.001:1-0.001)';
        d_vec = randn(1000,1);
        detectorSamples = 5;
    end
    methods (Test)
        function testBasicPositiveCase(testCase)
            stamps = [0.5];
            [obs, tf, new_stamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'examplesArePositives', true, ...
                'jitterPositive', false, 'makeShoulderNegatives', false);
            testCase.verifyEqual(size(obs), [testCase.detectorSamples, 1]);
            testCase.verifyTrue(all(tf));
            testCase.verifyEqual(stamps, new_stamps, 'AbsTol', 1e-9);
        end

        function testBasicNegativeCase(testCase)
            stamps = [0.5];
            [obs, tf, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'examplesArePositives', false, ...
                'jitterPositive', false, 'makeShoulderNegatives', false);
            testCase.verifyEqual(size(obs), [testCase.detectorSamples, 1]);
            testCase.verifyFalse(all(tf));
        end

        function testJitter(testCase)
            stamps = [0.5];
            jitterRange = 0.002;
            [obs, tf, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'jitterPositive', true, 'jitterRange', jitterRange, ...
                'makeShoulderNegatives', false);

            expected_num_obs = 1 + 2 * (jitterRange / 0.001);
            testCase.verifyEqual(size(obs, 2), expected_num_obs);
            testCase.verifyTrue(all(tf));
        end

        function testShoulderNegatives(testCase)
            stamps = [0.5];
            [obs, tf, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'jitterPositive', false, ...
                'makeShoulderNegatives', true);

            % Should have 1 positive and many negative 'shoulder' examples
            testCase.verifyTrue(sum(tf) == 1);
            testCase.verifyTrue(sum(~tf) > 1);
        end

        function testCombinedAugmentation(testCase)
            stamps = [0.5];
            [obs, tf, ~] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'jitterPositive', true, ...
                'makeShoulderNegatives', true);

            num_pos = sum(tf);
            num_neg = sum(~tf);

            testCase.verifyTrue(num_pos > 1);
            testCase.verifyTrue(num_neg > 1);
            testCase.verifyEqual(size(obs, 2), num_pos + num_neg);
        end

        function testPeakFinding(testCase)
            stamps = [0.5];
            % Create a peak
            testCase.d_vec(502) = 10; % peak at t=0.501

            [~, ~, new_stamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, 'jitterPositive', false, ...
                'makeShoulderNegatives', false, 'optimizeForPeak', true);

            testCase.verifyEqual(new_stamps, 0.501, 'AbsTol', 1e-9);
        end
    end
end