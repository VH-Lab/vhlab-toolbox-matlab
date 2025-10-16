classdef testBase < matlab.unittest.TestCase
    % TESTBASE - Unit tests for the vlt.signal.timeseriesDetectorML.base class

    properties
        t_vec = (0:0.001:1-0.001)';
        d_vec = randn(1000,1);
        detectorSamples = 10;
    end

    methods (Test)
        function testTimeStamps2Observations(testCase)
            stamps = [0.5];
            [obs, tf, newStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testCase.d_vec, stamps, testCase.detectorSamples, true);

            testCase.verifyEqual(size(obs), [testCase.detectorSamples, 1]);
            testCase.verifyTrue(tf);
            testCase.verifyEqual(stamps, newStamps);
        end

        function testPeakOptimization(testCase)
            stamps = [0.5];
            testData = zeros(size(testCase.t_vec));
            peak_idx = 505;
            testData(peak_idx) = 1;
            [~, ~, newStamps] = vlt.signal.timeseriesDetectorML.base.timeStamps2Observations(...
                testCase.t_vec, testData, stamps, testCase.detectorSamples, true, 'optimizeForPeak', true);
            testCase.verifyEqual(newStamps, testCase.t_vec(peak_idx), 'AbsTol', 1e-9);
        end

        function testJitter(testCase)
            stamps = [0.5];
            [~, ~, jittered_stamps] = vlt.signal.timeseriesDetectorML.base.jitterPositiveObservations(...
                stamps, testCase.t_vec, testCase.d_vec, testCase.detectorSamples, 'jitterRange', 0.002);
            testCase.verifyNotEmpty(jittered_stamps);
            testCase.verifyTrue(all(abs(jittered_stamps - stamps) <= 0.002 + 1e-9));
        end

        function testShoulders(testCase)
            stamps = [0.5];
            [~, ~, shoulder_stamps] = vlt.signal.timeseriesDetectorML.base.shoulderNegativeObservations(...
                stamps, testCase.t_vec, testCase.d_vec, testCase.detectorSamples, 'shoulderRangeStart', 0.010, 'shoulderRangeStop', 0.012);
            testCase.verifyNotEmpty(shoulder_stamps);
            distances = abs(shoulder_stamps - stamps);
            testCase.verifyTrue(all(distances >= 0.010 - 1e-9 & distances <= 0.012 + 1e-9));
        end

        function testDetectIndividualEvents(testCase)
            detectorOutput = zeros(1, numel(testCase.t_vec));
            detectorOutput(250) = 1.0;
            detectorOutput(260) = 0.8;
            detectorOutput(750) = 0.9;

            [eventTimes, ~] = vlt.signal.timeseriesDetectorML.base.detectIndividualEvents(...
                testCase.t_vec, detectorOutput, 'threshold', 0.5, 'refractoryPeriod', 0.020);

            expected_times = [testCase.t_vec(250); testCase.t_vec(750)];
            testCase.verifyEqual(numel(eventTimes), 2);
            testCase.verifyEqual(sort(eventTimes(:)), sort(expected_times(:)), 'AbsTol', 1e-9);
        end
    end
end